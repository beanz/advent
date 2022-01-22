#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <queue>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>
#include <string.h>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>
#include "point.hpp"

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

struct CompareSteps1 {
    bool operator()(Search1 const& l, Search1 const& r) {
        return l.steps > r.steps;
    }
};

struct Search2 {
  vector<int> key;
  int steps;
  int num_keys;
  string path;
  int key_set;
};

struct CompareSteps2 {
    bool operator()(Search2 const& l, Search2 const& r) {
        return l.steps > r.steps;
    }
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
  unsigned char* m;
  int w, h;
  Keys *keys;
  Point pos;
private:
  void init(unsigned int inp_len, unsigned char *inp) {
    m = inp;
    keys = new Keys();
    w = 0;
    while (inp[w] != '\n' && w < inp_len) { w++; }
    h = inp_len/(w+1);
    w++; // need to account for newlines
    pos = Point{-1,-1};
    for (auto y = 0; y < h; y++) {
      for (auto x = 0; x < (w-1); x++) {
        auto ch = inp[y*w+x];
        if (ch == '@') {
          pos = Point{x,y};
          m[y*w+x] = '.';
        } else if ('a' <= ch && ch <= 'z') {
          keys->insert(make_pair(key_int(ch), Point{x,y}));
        }
      }
    }
  }
public:
  Maze(unsigned int inp_len, unsigned char *inp) {
    init(inp_len, inp);
  }
  Maze(std::pair<unsigned char *, unsigned int> p) {
    unsigned char* inp = (unsigned char*)malloc(p.second);
    memcpy(inp, p.first, p.second);
    init(p.second, inp);
  }
  auto optimaze() {
    int changes = 1;
    while (changes > 0) {
      changes = 0;
      for (auto y = 0; y < h; y++) {
        for (auto x = 0; x < (w-1); x++) {
          auto ch = m[y*w+x];
          if (ch != '.' || (pos.x == x && pos.y == y)) {
            continue;
          }
          int wall = 0;
          if (m[y*w+x-1] == '#') { wall++; }
          if (m[y*w+x+1] == '#') { wall++; }
          if (m[(y-1)*w+x] == '#') { wall++; }
          if (m[(y+1)*w+x] == '#') { wall++; }
          if (wall > 2) {
            m[y*w+x] = '#';
            changes++;
          }
        }
      }
    }
  }
  auto pp() {
    std::stringstream ss;
    for (auto y = 0; y < h; y++) {
      for (auto x = 0; x < (w-1); x++) {
        if (pos.x == x && pos.y == y) {
          ss << "@";
        } else {
          ss << m[y*w+x];
        }
      }
      ss << "\n";
    }
    return ss.str();
  }
  auto find_paths(Point p, char kch) {
    bool visited[81*81] = { 0 };
    auto res = new map<int,Search>;
    deque<Search> search;
    search.push_back(Search{p, 0, 0});
    while (search.size() > 0) {
      auto cur = search.front();
      search.pop_front();
      auto cur_i = cur.pos.y*w+cur.pos.x;
      auto ch = m[cur_i];
      if (ch == '#') {
        continue;
      }
      if (visited[cur_i]) {
        continue;
      }
      visited[cur_i] = true;
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
    std::priority_queue<Search1, vector<Search1>, CompareSteps1> search;
    search.push(Search1{-1, 0, expected_keys, "", 0});
    auto visited = new map<string,int>;
    while (!search.empty()) {
      auto cur = search.top();
      search.pop();
      if (cur.num_keys == 0) {
        //printf("Found: %s %d\n", cur.path.c_str(), cur.steps);
        return cur.steps;
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
        search.push(Search1{
            ink, new_steps, cur.num_keys-1,
              cur.path + int_key(ink), cur.key_set | ink});
      }
    }
    delete visited;
    delete paths;
    return 0;
  }
  int part2() {
    m[(pos.y-1)*w+pos.x] = '#';
    m[pos.y*w+pos.x-1] = '#';
    m[pos.y*w+pos.x+1] = '#';
    m[(pos.y+1)*w+pos.x] = '#';
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
    std::priority_queue<Search2, vector<Search2>, CompareSteps2> search;
    search.push(Search2{{-1,-1,-1,-1}, 0, expected_keys, "", 0});
    auto visited = new map<string,int>;
    while (!search.empty()) {
      auto cur = search.top();
      search.pop();
      if (cur.num_keys == 0) {
        //printf("Found: %s %d\n", cur.path.c_str(), cur.steps);
        return cur.steps;
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
          search.push(Search2{
              new_key, new_steps, cur.num_keys-1,
                cur.path + int_key(ink), cur.key_set | ink});
        }
      }
    }
    delete visited;
    return 0;
  }
};

void tests() {
  AIEQ((new Maze(getfile("test1a.txt")))->part1(), 8);
  AIEQ((new Maze(getfile("test1b.txt")))->part1(), 86);
  AIEQ((new Maze(getfile("test1c.txt")))->part1(), 132);
  AIEQ((new Maze(getfile("test1d.txt")))->part1(), 136);
  AIEQ((new Maze(getfile("test1e.txt")))->part1(), 81);
  AIEQ((new Maze(getfile("test2a.txt")))->part2(), 8);
  AIEQ((new Maze(getfile("test2b.txt")))->part2(), 24);
  AIEQ((new Maze(getfile("test2c.txt")))->part2(), 32);
  AIEQ((new Maze(getfile("test2d.txt")))->part2(), 72);
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto maze = new Maze(inp_len, inp);
  maze->optimaze();
  //cout << maze->pp() << "\n";
  auto p1 = maze->part1();
  auto p2 = maze->part2();
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
