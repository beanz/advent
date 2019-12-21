#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>
#include "../../lib/assert.hpp"
#include "../../lib/input.hpp"
#include "../../lib/intcode.hpp"
#include "../../lib/point.hpp"

using namespace std;

string pp_deque(const deque<long> v) {
  std::stringstream ss;
  for(size_t i = 0; i < v.size(); ++i) {
    if(i != 0)
      ss << ",";
    ss << v[i];
  }
  return ss.str();
}

string pp_vector(const vector<long> v) {
  std::stringstream ss;
  for(size_t i = 0; i < v.size(); ++i) {
    if(i != 0)
      ss << " ";
    ss << v[i];
  }
  return ss.str();
}

typedef map<Point,bool> Tiles;

class Hull {
  Tiles* tiles;
  Point pos;
  BoundingBox* bb;
  Direction* dir;
public:
  Hull() : pos({0,0}) {
    tiles = new Tiles();
    dir = new Direction(0,-1);
    bb = new BoundingBox();
  }
  auto size() {
    return tiles->size();
  }
  auto input() {
    auto e = tiles->find(pos);
    if (e != tiles->end() && e->second) {
      return 1;
    } else {
      return 0;
    }
  }
  auto output(bool val) {
    (*tiles)[pos] = val;
  }
  auto process(int col, int turn) {
    output(col == 1 ? true : false);
    if (turn == 1) {
      dir = dir->CW();
    } else {
      dir = dir->CCW();
    }
    pos = Point{pos.x + dir->X(), pos.y + dir->Y()};
    bb->Add(pos);
  }
  auto pp() {
    std::stringstream ss;
    for (auto y = bb->MinY(); y <= bb->MaxY(); y++) {
      for (auto x = bb->MinX(); x <= bb->MaxX(); x++) {
        auto p = Point{x,y};
        auto e = tiles->find(p);
        if (e != tiles->end() && e->second) {
          ss << "#";
        } else {
          ss << ".";
        }
      }
      ss << "\n";
    }
    return ss.str();
  }
};

auto run(const vector<long>* prog, long input) {
  auto h = new Hull();
  auto ic = new IntCode(prog, input);
  while (!ic->Done()) {
    ic->run();
    if (ic->outp.size() == 2) {
      auto col = ic->outp.front();
      ic->outp.pop_front();
      auto turn = ic->outp.front();
      ic->outp.pop_front();
      h->process(col, turn);
      ic->inp.push_back(h->input());
    }
  }
  return h;
}

int part1(const vector<long>* prog) {
  return run(prog, 0)->size();
}

string part2(const vector<long>* prog) {
  auto h = run(prog, 1);
  return h->pp();
}

int main(int argc, char *argv[]) {
  string file = "input.txt";
  if (argc > 1) {
    file = argv[1];
  }
  vector<long> prog = readints(file);
  if (getenv("AoC_TEST")) {
    //AIEQ((new Donut(readlines("test1a.txt")))->part1(), 23);
  }

  cout << "Part 1: " << part1(&prog) << "\n";
  cout << "Part 2:\n" << part2(&prog) << "\n";
}
