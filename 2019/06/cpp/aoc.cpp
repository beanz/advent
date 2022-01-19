#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include <map>
#include <limits>

using namespace std;

#include "input.h"
#include "assert.hpp"
#include "input.hpp"

typedef map<string,string> Orbits;
typedef map<string,int> ParentDist;
typedef map<string,ParentDist*> Cache;

typedef struct {
  Orbits orbits;
  Cache cache;
} Game;

auto parse(vector<string> inp) {
  auto g = new Game;
  for (auto l : inp) {
    auto bracket = l.find(')');
    auto o0 = l.substr(0, bracket);
    auto o1 = l.substr(bracket+1);
    g->orbits.insert(std::make_pair(o1, o0));
  }
  return g;
}

auto parents(Game* g, string obj) {
  auto citr = g->cache.find(obj);
  if (citr != g->cache.end()) {
    return citr->second;
  }
  auto p = new ParentDist;
  auto itr = g->orbits.find(obj);
  if (itr == g->orbits.end()) {
    g->cache.insert(std::make_pair(obj, p));
    return p;
  }
  auto parent = itr->second;
  p->insert(std::make_pair(parent, 0));
  for (auto pd : *parents(g, parent)) {
    p->insert(std::make_pair(pd.first, pd.second + 1));
  }
  g->cache.insert(std::make_pair(obj, p));
  return p;
}

int part1(Game* g) {
  int s = 0;
  for (auto d : g->orbits) {
    s += parents(g, d.first)->size();
  }
  return s;
}

int part2(Game* g) {
  auto p1 = parents(g, "YOU");
  auto p2 = parents(g, "SAN");
  int min = std::numeric_limits<int>::max();
  for (auto pd : *p1) {
    auto itr = p2->find(pd.first);
    if (itr == p2->end()) {
      continue;
    }
    int d = pd.second + itr->second;
    if (min > d) {
      min = d;
    }
  }
  return min;
}

void tests() {
  AIEQ(part1(parse(vector<string>{
    "COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H",
      "D)I", "E)J", "J)K", "K)L"})), 42);
  AIEQ(part2(parse(vector<string>{
    "COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H",
    "D)I", "E)J", "J)K", "K)L", "K)YOU", "I)SAN"})), 4);
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto g = parse(lines(inp_len, inp));
  auto p1 = part1(g);
  auto p2 = part2(g);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
