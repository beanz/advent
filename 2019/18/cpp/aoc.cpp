#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>
#include "point.hpp"
#include "input.hpp"

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

#define ASEQ(act,exp) { if (act != exp) { throw std::runtime_error("assert: " + act + " should equal " + exp); } }

typedef map<Point,bool> Map;
typedef map<int,Point> Keys;

struct Search {
  Point pos;
  int steps;
  int needed;
};
typedef map<int, map<int,Search>*> Paths;

struct Search1 {
  int key;
  int steps;
  int num_keys;
  string path;
  int key_set;
};

struct Search2 {
  vector<int> key;
  int steps;
  int num_keys;
  string path;
  int key_set;
};

inline int key_int(char ch) {
  return 1 << ((ch-1)&0x1f);
}

inline char int_key(int k) {
  if (k == -1) {
    return '@';
  } else {
    char ch = 'a';
    for (int i = 1; ; i <<= 1) {
      if ((i & k) != 0) {
        return ch;
      }
      ch++;
    }
  }
  return '?';
}

string visitkey(Search1 cur) {
  std::stringstream ss;
  ss << cur.key << "!" << cur.key_set;
  return ss.str();
}

string visitkey2(Search2 cur) {
  std::stringstream ss;
  ss << cur.key[0] << "!"
     << cur.key[1] << "!"
     << cur.key[2] << "!"
     << cur.key[3] << "!"
     << cur.key_set;
  return ss.str();
}

class Maze {
  vector<string> m;
  BoundingBox *bb;
  Keys *keys;
  Point pos;
public:

  Maze(const vector<string> &lines) {
    m = lines;
    keys = new Keys();
    bb = new BoundingBox();
    pos = Point{-1,-1};
    bb->Add(Point{0,0});
    bb->Add(Point{((int)lines[0].size())-1, ((int)lines.size())-1});
    for (auto y = bb->MinY(); y <= bb->MaxY(); y++) {
      for (auto x = bb->MinX(); x <= bb->MaxX(); x++) {
        auto ch = lines[y][x];
        if (ch == '@') {
          pos = Point{x,y};
          m[y][x] = '.';
        } else if ('a' <= ch && ch <= 'z') {
          keys->insert(make_pair(key_int(ch), Point{x,y}));
        }
      }
    }
  }

  auto optimaze() {
    int changes = 1;
    while (changes > 0) {
      changes = 0;
      for (auto y = bb->MinY(); y <= bb->MaxY(); y++) {
        for (auto x = bb->MinX(); x <= bb->MaxX(); x++) {
          auto ch = m[y][x];
          if (ch != '.' || (pos.x == x && pos.y == y)) {
            continue;
          }
          int w = 0;
          if (m[y][x-1] == '#') { w++; }
          if (m[y][x+1] == '#') { w++; }
          if (m[y-1][x] == '#') { w++; }
          if (m[y+1][x] == '#') { w++; }
          if (w > 2) {
            m[y][x] = '#';
            changes++;
          }
        }
      }
    }
  }
  auto pp() {
    std::stringstream ss;
    for (auto y = bb->MinY(); y <= bb->MaxY(); y++) {
      for (auto x = bb->MinX(); x <= bb->MaxX(); x++) {
        if (pos.x == x && pos.y == y) {
          ss << "@";
        } else {
          ss << m[y][x];
        }
      }
      ss << "\n";
    }
    return ss.str();
  }
  auto find_paths(Point p, char kch) {
    auto visited = new map<Point,bool>;
    auto res = new map<int,Search>;
    deque<Search> search;
    search.push_back(Search{p, 0, 0});
    while (search.size() > 0) {
      auto cur = search.front();
      search.pop_front();
      auto ch = m[cur.pos.y][cur.pos.x];
      if (ch == '#') {
        continue;
      }
      if (visited->find(cur.pos) != visited->end()) {
        continue;
      }
      (*visited)[cur.pos] = true;
      if ('a' <= ch && ch <= 'z' and ch != kch) {
        res->insert(make_pair(key_int(ch),
                              Search{cur.pos, cur.steps, cur.needed}));
      } else if ('A' <= ch && ch <= 'Z') {
        cur.needed |= key_int(ch);
      }
      search.push_back(Search{
          Point{cur.pos.x, cur.pos.y-1}, cur.steps + 1, cur.needed});
      search.push_back(Search{
          Point{cur.pos.x-1, cur.pos.y}, cur.steps + 1, cur.needed});
      search.push_back(Search{
          Point{cur.pos.x+1, cur.pos.y}, cur.steps + 1, cur.needed});
      search.push_back(Search{
          Point{cur.pos.x, cur.pos.y+1}, cur.steps + 1, cur.needed});
    }
    delete visited;
    return res;
  }
  int part1() {
    auto paths = new Paths;
    paths->insert(make_pair(-1, find_paths(pos, '@')));
    for (auto k : (*keys)) {
      paths->insert(make_pair(k.first,
                              find_paths(k.second, int_key(k.first))));
    }
    int expected_keys = keys->size();
    deque<Search1> search;
    search.push_back(Search1{-1, 0, expected_keys, "", 0});
    auto visited = new map<string,int>;
    int min = numeric_limits<int>::max();
    while (search.size() > 0) {
      auto cur = search.front();
      search.pop_front();
      if (cur.num_keys == 0) {
        //printf("Found: %s %d\n", cur.path.c_str(), cur.steps);
        if (cur.steps < min) {
          min = cur.steps;
        }
        continue;
      }
      string vkey = visitkey(cur);
      auto elt = visited->find(vkey);
      if (elt != visited->end() && elt->second <= cur.steps) {
        continue;
      }
      (*visited)[vkey] = cur.steps;
      //printf("Finding next paths from %d p=%s\n", cur.key, cur.path.c_str());
      for (auto p : *(*paths)[cur.key]) {
        int ink = p.first;
        if ((cur.key_set & ink) != 0) {
          continue;
        }
        int blocked = (p.second.needed | cur.key_set) ^ cur.key_set;
        //printf("  %d | %d ~~ %d\n", p.second.needed, cur.key_set, blocked);
        if (blocked != 0) {
          //printf("  %d (%c) blocked by %d (%c)\n",
          //       ink, int_key(ink), blocked, int_key(blocked));
          continue;
        }
        int new_steps = cur.steps + p.second.steps;
        //printf("  adding %d (%c)\n", ink, int_key(ink));
        search.push_back(Search1{
            ink, new_steps, cur.num_keys-1,
              cur.path + int_key(ink), cur.key_set | ink});
      }
    }
    delete visited;
    delete paths;
    return min;
  }
  int part2() {
    m[pos.y-1][pos.x] = '#';
    m[pos.y][pos.x-1] = '#';
    m[pos.y][pos.x+1] = '#';
    m[pos.y+1][pos.x] = '#';
    vector<Paths> paths;
    for (auto off : {Point{-1,-1},Point{1,-1},Point{-1,1},Point{1,1}}) {
      auto start = Point{pos.x+off.x, pos.y+off.y};
      auto p = new Paths;
      p->insert(make_pair(-1, find_paths(start, '@')));
      for (auto k : (*keys)) {
        p->insert(make_pair(k.first,
                            find_paths(k.second, int_key(k.first))));
      }
      paths.push_back(*p);
    }
    int expected_keys = keys->size();
    deque<Search2> search;
    search.push_back(Search2{{-1,-1,-1,-1}, 0, expected_keys, "", 0});
    auto visited = new map<string,int>;
    int min = numeric_limits<int>::max();
    while (search.size() > 0) {
      auto cur = search.front();
      search.pop_front();
      if (cur.num_keys == 0) {
        //printf("Found: %s %d\n", cur.path.c_str(), cur.steps);
        if (cur.steps < min) {
          min = cur.steps;
        }
        continue;
      }
      string vkey = visitkey2(cur);
      auto elt = visited->find(vkey);
      if (elt != visited->end() && elt->second <= cur.steps) {
        continue;
      }
      (*visited)[vkey] = cur.steps;
      //printf("Finding next paths from %d p=%s\n", cur.key, cur.path.c_str());
      for (int i = 0; i < 4; i++) {
        for (auto p : *(paths[i])[cur.key[i]]) {
          int ink = p.first;
          if ((cur.key_set & ink) != 0) {
            continue;
          }
          int blocked = (p.second.needed | cur.key_set) ^ cur.key_set;
          //printf("  %d | %d ~~ %d\n", p.second.needed, cur.key_set, blocked);
          if (blocked != 0) {
            //printf("  %d (%c) blocked by %d (%c)\n",
            //       ink, int_key(ink), blocked, int_key(blocked));
            continue;
          }
          int new_steps = cur.steps + p.second.steps;
          //printf("  adding %d (%c)\n", ink, int_key(ink));
          vector<int> new_key = cur.key;
          new_key[i] = ink;
          search.push_back(Search2{
              new_key, new_steps, cur.num_keys-1,
                cur.path + int_key(ink), cur.key_set | ink});
        }
      }
    }
    delete visited;
    return min;
  }
};

int main(int argc, char** argv) {
  string file = "input.txt";
  if (argc > 1) {
    file = argv[1];
  }
  vector<string> lines = readlines(file);

  if (getenv("AoC_TEST")) {
    AIEQ((new Maze(readlines("test1a.txt")))->part1(), 8);
    AIEQ((new Maze(readlines("test1b.txt")))->part1(), 86);
    AIEQ((new Maze(readlines("test1c.txt")))->part1(), 132);
    AIEQ((new Maze(readlines("test1d.txt")))->part1(), 136);
    AIEQ((new Maze(readlines("test1e.txt")))->part1(), 81);
    AIEQ((new Maze(readlines("test2a.txt")))->part2(), 8);
    AIEQ((new Maze(readlines("test2b.txt")))->part2(), 24);
    AIEQ((new Maze(readlines("test2c.txt")))->part2(), 32);
    AIEQ((new Maze(readlines("test2d.txt")))->part2(), 72);
    cout << "TESTS PASSED\n";
  }
  auto maze = new Maze(lines);
  maze->optimaze();
  //cout << maze->pp() << "\n";
  cout << "Part 1: " << maze->part1() << "\n";
  cout << "Part 2: " << maze->part2() << "\n";
}
