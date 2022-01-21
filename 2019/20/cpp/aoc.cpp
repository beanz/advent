#include <stdio.h>
#include <cstdlib>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <assert.h>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>
#include "point.hpp"

struct Portal {
  Point exit;
  uint16_t name;
  int level;
};

struct Search {
  Point pos;
  int steps;
  int level;
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
private:
  void init(unsigned int inp_len, unsigned char *inp) {
    m = new map<Point,bool>();
    p = new map<Point,Portal>();
    int i = 0;
    while (inp[i] != '\n' && i < inp_len) {
      i++;
    }
    int w = i+1;
    int h = inp_len/w;
    bb = new BoundingBox();
    start = Point{-1, -1};
    exit = Point{-1, -1};
    bb->Add(Point{0,0});
    bb->Add(Point{w-2, h-1});
    auto isPortal = [&](int x, int y) {
      return 'A' <= inp[y*w+x] && inp[y*w+x] <= 'Z';
    };
    auto rp = new map<uint16_t,Point>();
    auto addPortal = [&](Point pp, int bx, int by, char ch1, char ch2) {
      uint16_t name = (ch1-'@')*27 + (ch2-'@');
      m->insert(make_pair(Point{bx,by}, true));
      if (name == ('A'-'@')*27+('A'-'@')) {
        // printf("found start at %d,%d\n", pp.x, pp.y);
        start = pp;
        return;
      }
      if (name == ('Z'-'@')*27+('Z'-'@')) {
        // printf("found exit at %d,%d\n", pp.x, pp.y);
        exit = pp;
        return;
      }
      int level = 1;
      if (pp.y == 2 ||
          pp.y == bb->MaxY()-2 ||
          pp.x == 2 ||
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
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        auto p = Point{x,y};
        if (inp[y*w+x] == '#') {
          m->insert(make_pair(p,true));
        } else if (inp[y*w+x] == '.') {
          if (isPortal(x,y-2) && isPortal(x, y-1)) {
            addPortal(p, x, y-1, inp[(y-2)*w+x], inp[(y-1)*w+x]);
          } else if (isPortal(x, y+1) && isPortal(x, y+2)) {
            addPortal(p, x, y+1, inp[(y+1)*w+x], inp[(y+2)*w+x]);
          } else if (isPortal(x-2, y) &&
                     isPortal(x-1, y)) {
            addPortal(p, x-1, y, inp[y*w+x-2], inp[y*w+x-1]);
          } else if (isPortal(x+1, y) &&
                     isPortal(x+2, y)) {
            addPortal(p, x+1, y, inp[y*w+x+1], inp[y*w+x+2]);
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
public:
  Donut(unsigned int inp_len, unsigned char *inp) {
    init(inp_len, inp);
  }
  Donut(std::pair<unsigned char *, unsigned int> p) {
    init(p.second, p.first);
  }
  int search(bool recurse) {
    deque<Search> search;
    auto visited = new map<VKey,bool>();
    search.push_back(Search{start, 0, 0});
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
      //        cur.pos.x, cur.pos.y, cur.level, cur.steps);
      if (cur.level == 0 && cur.pos.x == exit.x && cur.pos.y == exit.y) {
        // printf("  escaped\n");
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
          search.push_back(Search{portal.exit, cur.steps+1, nlevel});
        }
      }
      for (auto np : cur.pos.neighbours()) {
        search.push_back(Search{np, cur.steps+1, cur.level});
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

void tests() {
  AIEQ((new Donut(getfile("test1a.txt")))->part1(), 23);
  AIEQ((new Donut(getfile("test1b.txt")))->part1(), 58);
  AIEQ((new Donut(getfile("input.txt")))->part1(), 482);
  AIEQ((new Donut(getfile("test1a.txt")))->part2(), 26);
  AIEQ((new Donut(getfile("test2a.txt")))->part2(), 396);
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto donut = new Donut(inp_len, inp);
  // cout << donut << "\n";
  auto p1 = donut->part1();
  auto p2 = donut->part2();
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
