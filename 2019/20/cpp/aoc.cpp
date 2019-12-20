#include <stdio.h>
#include <cstdlib>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <assert.h>
#include "../../lib/point.hpp"
#include "../../lib/input.hpp"

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

struct Portal {
  Point exit;
  string name;
  int level;
};

struct Search {
  Point pos;
  int steps;
  int level;
  string path;
};

struct VKey {
  Point pos;
  int level;
  bool operator<(const VKey& b) const {
    return level < b.level || (level == b.level && pos < b.pos);
  }
};

class Donut {
  map<Point,bool>* m;
  map<Point,Portal>* p;
  BoundingBox* bb;
  Point start;
  Point exit;
public:
  Donut(vector<string> lines) {
    m = new map<Point,bool>();
    p = new map<Point,Portal>();
    bb = new BoundingBox();
    start = Point{-1, -1};
    exit = Point{-1, -1};
    bb->Add(Point{0,0});
    bb->Add(Point{((int)lines[0].size())-1, ((int)lines.size())-1});
    auto isPortal = [&](int x, int y) {
      return 'A' <= lines[y][x] && lines[y][x] <= 'Z';
    };
    auto rp = new map<string,Point>();
    auto addPortal = [&](Point pp, int bx, int by, char ch1, char ch2) {
      string ch1s(1, ch1);
      string ch2s(1, ch2);
      string name = ch1s + ch2s;
      m->insert(make_pair(Point{bx,by}, true));
      if (name == "AA") {
        // printf("found start at %d,%d\n", pp.x, pp.y);
        start = pp;
        return;
      }
      if (name == "ZZ") {
        // printf("found exit at %d,%d\n", pp.x, pp.y);
        exit = pp;
        return;
      }
      int level = 1;
      if (pp.y == bb->MinY()+2 ||
          pp.y == bb->MaxY()-2 ||
          pp.x == bb->MinX()+2 ||
          pp.x == bb->MaxX()-2) {
        // outer portal
        level = -1;
        // printf("Found outer portal %s %d,%d\n",
        //        name.c_str(), pp.x, pp.y);
      } else {
        // printf("Found inner portal %s %d,%d\n",
        //        name.c_str(), pp.x, pp.y);
      }
      auto f = rp->find(name);
      if (f != rp->end()) {
        auto exit = (*rp)[name];
        // printf("  %d, %d => %d,%d\n", pp.x, pp.y, exit.x, exit.y);
        // printf("  %d, %d => %d,%d\n", exit.x, exit.y, pp.x, pp.y);
        p->insert(make_pair(pp,Portal{exit, name, level}));
        p->insert(make_pair(exit,Portal{pp, name, -1*level}));
        rp->erase(name);
      } else {
        (*rp)[name] = pp;
      }
    };
    for (int y = 0; y < lines.size(); y++) {
      for (int x = 0; x < lines[y].size(); x++) {
        auto p = Point{x,y};
        if (lines[y][x] == '#') {
          m->insert(make_pair(p,true));
        } else if (lines[y][x] == '.') {
          if (isPortal(x,y-2) && isPortal(x, y-1)) {
            addPortal(p, x, y-1, lines[y-2][x], lines[y-1][x]);
          } else if (isPortal(x, y+1) && isPortal(x, y+2)) {
            addPortal(p, x, y+1, lines[y+1][x], lines[y+2][x]);
          } else if (isPortal(x-2, y) &&
                     isPortal(x-1, y)) {
            addPortal(p, x-1, y, lines[y][x-2], lines[y][x-1]);
          } else if (isPortal(x+1, y) &&
                     isPortal(x+2, y)) {
            addPortal(p, x+1, y, lines[y][x+1], lines[y][x+2]);
          }
        }
      }
    }
    if (rp->size() != 0) {
      cout << "some portals not connected:\n";
      for (auto e : (*rp)) {
        cout << e.first << ":" << e.second.x << "," << e.second.y << "\n";
      }
      std::exit(1);
    }
    delete rp;
  }
  int search(bool recurse) {
    deque<Search> search;
    auto visited = new map<VKey,bool>();
    search.push_back(Search{start, 0, 0, ""});
    while (search.size() > 0) {
      auto cur = search.front();
      search.pop_front();
      if (m->find(cur.pos) != m->end()) {
        continue;
      }
      auto vkey = VKey{cur.pos, cur.level};
      if (visited->find(vkey) != visited->end()) {
        continue;
      }
      (*visited)[vkey] = true;
      // printf("Trying %d,%d @ %d (%d '%s')\n",
      //        cur.pos.x, cur.pos.y, cur.level, cur.steps, cur.path.c_str());
      if (cur.level == 0 && cur.pos.x == exit.x && cur.pos.y == exit.y) {
        // printf("  escaped %s\n", cur.path.c_str());
        return cur.steps;
      }
      auto elt = p->find(cur.pos);
      if (elt != p->end()) {
        auto portal = elt->second;
        int nlevel = cur.level;
        if (recurse) {
          nlevel += portal.level;
        }
        // printf("  found %s to %d,%d, level %d\n",
        //        portal.name.c_str(), portal.exit.x, portal.exit.y, nlevel);
        if (nlevel >= 0) {
          string npath =
            (cur.path.size() > 0 ? (cur.path + " ") : "") + portal.name;
          search.push_back(Search{portal.exit, cur.steps+1, nlevel, npath});
        }
      }
      for (auto np : cur.pos.neighbours()) {
        search.push_back(Search{np, cur.steps+1, cur.level, cur.path});
      }
    }
    delete visited;
    return -1;
  }
  int part1() {
    return search(false);
  }
  int part2() {
    return search(true);
  }
  inline friend std::ostream& operator<<(std::ostream& stream, Donut* const & d) {
    for (auto y = d->bb->MinY(); y <= d->bb->MaxY(); y++) {
      for (auto x = d->bb->MinX(); x <= d->bb->MaxX(); x++) {
        auto p = Point{x,y};
        if (d->start == p) {
          stream << 'S';
        } else if (d->exit.x == x && d->exit.y == y) {
          stream << 'E';
        } else if (d->p->find(p) != d->p->end()) {
          stream << "~";
        } else if (d->m->find(p) != d->m->end()) {
          stream << "#";
        } else {
          stream << ".";
        }
      }
      stream << "\n";
    }
    return stream;
  }
};

int main(int argc, char *argv[]) {
  string file = "input.txt";
  if (argc > 1) {
    file = argv[1];
  }
  vector<string> inp = readlines(file);
  if (getenv("AoC_TEST")) {
    AIEQ((new Donut(readlines("test1a.txt")))->part1(), 23);
    AIEQ((new Donut(readlines("test1b.txt")))->part1(), 58);
    AIEQ((new Donut(readlines("input.txt")))->part1(), 482);
    AIEQ((new Donut(readlines("test1a.txt")))->part2(), 26);
    AIEQ((new Donut(readlines("test2a.txt")))->part2(), 396);
    cout << "TESTS PASSED\n";
  }

  auto donut = new Donut(inp);
  // cout << donut << "\n";
  auto res = donut->part1();
  cout << "Part 1: " << res << "\n";
  res = donut->part2();
  cout << "Part 2: " << res << "\n";
}
