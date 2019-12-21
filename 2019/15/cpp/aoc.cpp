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

typedef map<Point,bool> Visited;
typedef map<Point,bool> Wall;
typedef map<Point,bool> Safe;

class Ship {
  Wall *wall;
  BoundingBox *bb;
public:
  Point* os;
  IntCode* osic;
  int steps;
  Ship() {
    wall = new Wall();
    bb = new BoundingBox();
    os = NULL;
    osic = NULL;
    steps = 0;
  }
  auto AddWall(Point pos) {
    (*wall)[pos] = true;
  }
  auto BB() {
    return bb;
  }
  auto pp() {
    std::stringstream ss;
    for (auto y = bb->MinY(); y <= bb->MaxY(); y++) {
      for (auto x = bb->MinX(); x <= bb->MaxX(); x++) {
        if (x == 0 && y == 0) {
          ss << "S";
        } else if (os != NULL && os->x == x && os->y == y) {
          ss << "O";
        } else {
          auto p = Point{x,y};
          auto e = wall->find(p);
          if (e != wall->end()) {
            ss << "#";
          } else {
            ss << ".";
          }
        }
      }
      ss << "\n";
    }
    return ss.str();
  }
};

struct SearchRecord {
  Point pos;
  int steps;
  IntCode* ic;
};

int CompassToInput(string c) {
  if (c == "N") {
    return 1;
  } else if (c == "S") {
    return 2;
  } else if (c == "W") {
    return 3;
  } else {
    return 4;
  }
}

int CompassXOffset(string c) {
  if (c == "N") {
    return 0;
  } else if (c == "S") {
    return 0;
  } else if (c == "W") {
    return -1;
  } else {
    return 1;
  }
}

int CompassYOffset(string c) {
  if (c == "N") {
    return -1;
  } else if (c == "S") {
    return 1;
  } else if (c == "W") {
    return 0;
  } else {
    return 0;
  }
}

auto part1(const vector<long>* prog) {
  const vector<string> DIRECTIONS{"N", "S", "W", "E"};
  deque<SearchRecord> search;
  auto ship = new Ship();
  auto start = Point{0, 0};
  for (auto dir : DIRECTIONS) {
    auto np = Point{start.x + CompassXOffset(dir),
                    start.y + CompassYOffset(dir)};
    search.push_back(SearchRecord{np,
          1, new IntCode(prog, CompassToInput(dir))});
  }
  auto visited = new Visited();
  while (search.size() > 0) {
    auto cur = search.front();
    search.pop_front();
    auto res = cur.ic->run_to_single_output();
    // printf("pos=%d,%d res=%d\n", cur.pos.x, cur.pos.y, res);
    ship->BB()->Add(cur.pos);
    if (res == 0) { // wall
      ship->AddWall(cur.pos);
    } else if (res == 1) {
      for (auto dir : DIRECTIONS) {
        auto np = Point{cur.pos.x + CompassXOffset(dir),
                        cur.pos.y + CompassYOffset(dir)};
        if ((*visited)[np]) {
          continue;
        }
        (*visited)[np] = true;
        search.push_back(SearchRecord{np,
              cur.steps + 1,
              cur.ic->CloneWithInput(CompassToInput(dir))});
      }
    } else if (res == 2) {
      ship->os = &(cur.pos);
      ship->osic = cur.ic;
      ship->steps = cur.steps;
    }
  }
  delete visited;
  return ship;
}

auto part2(Ship* ship) {
  const vector<string> DIRECTIONS{"N", "S", "W", "E"};
  deque<SearchRecord> search;
  auto start = *(ship->os);
  for (auto dir : DIRECTIONS) {
    auto np = Point{start.x + CompassXOffset(dir),
                    start.y + CompassYOffset(dir)};
    search.push_back(SearchRecord{np, 1,
          ship->osic->CloneWithInput(CompassToInput(dir))});
  }
  auto visited = new Visited();
  int max = numeric_limits<int>::min();
  while (search.size() > 0) {
    auto cur = search.front();
    search.pop_front();
    auto res = cur.ic->run_to_single_output();
    // printf("pos=%d,%d res=%d\n", cur.pos.x, cur.pos.y, res);
    ship->BB()->Add(cur.pos);
    if (res == 0) { // wall
      ship->AddWall(cur.pos);
    } else if (res == 1) {
      if (cur.steps > max) {
        max = cur.steps;
      }
      for (auto dir : DIRECTIONS) {
        auto np = Point{cur.pos.x + CompassXOffset(dir),
                        cur.pos.y + CompassYOffset(dir)};
        if ((*visited)[np]) {
          continue;
        }
        (*visited)[np] = true;
        search.push_back(SearchRecord{np,
              cur.steps + 1,
              cur.ic->CloneWithInput(CompassToInput(dir))});
      }
    } else if (res == 2) {
      ship->os = &(cur.pos);
      ship->osic = cur.ic;
      ship->steps = cur.steps;
    }
  }
  delete visited;
  return max;
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

  auto ship = part1(&prog);
  cout << "Part 1: " << ship->steps << "\n";
  cout << "Part 2: " << part2(ship) << "\n";
}
