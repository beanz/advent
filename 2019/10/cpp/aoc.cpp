#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include <map>
#include <limits>
#include <cmath>
#include <algorithm>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>
#include "intcode.hpp"

const double PI = acos(-1);

struct Asteroid {
  int x, y;
  bool operator<(const Asteroid& b) const {
    return x < b.x || (x == b.x && y < b.y);
  }

  bool operator==(const Asteroid& b) const {
    return x == b.x && y == b.y;
  }
};

namespace std {
    template<> struct hash<Asteroid>
    {
        std::uint64_t operator()(const Asteroid& a) const noexcept
        {
            return std::hash<int>()(a.x) * 31 + std::hash<int>()(a.y);
        }
    };
}

typedef pair<Asteroid,Asteroid> AsteroidPair;
typedef pair<Asteroid,double> AsteroidAngle;
typedef map<AsteroidPair,int> BlockersCache;
typedef map<Asteroid,bool> Asteroids;

bool operator<(const AsteroidAngle& a, const AsteroidAngle& b) {
  return a.second < b.second;
}

int mgcd(int a, int b) {
  a = a < 0 ? -a : a;
  b = b < 0 ? -b : b;
  if (a > b) {
    swap(a,b);
  }
  while (a != 0) {
    int t = a;
    a = b % a;
    b = t;
  }
  return b;
}

class Game {
  Asteroids* asteroids;
  Asteroid best;
  BlockersCache* blockers;
public:
  Game(unsigned char* inp, size_t len) {
    asteroids = new Asteroids();
    blockers = new BlockersCache();
    int y = 0;
    int x = 0;
   LOOP:
    for (auto i = 0; i < len; i++) {
      if (inp[i] == '#') {
        asteroids->insert(make_pair(Asteroid{x, y}, true));
      } else if (inp[i] == 'X') {
        asteroids->insert(make_pair(Asteroid{x, y}, true));
        best = Asteroid{x, y};
      } else if (inp[i] == '\n') {
        y++;
        x = 0;
        continue;
      }
      x += 1;
    }
  }
  auto num_blockers(Asteroid a1, Asteroid a2) {
    auto ap = AsteroidPair{a1,a2};
    auto e = blockers->find(ap);
    if (e != blockers->end()) {
      return e->second;
    }
    int num_blockers = 0;
    if (a1.x == a2.x) {
      int min_y = a1.y < a2.y ? a1.y : a2.y;
      int max_y = a1.y > a2.y ? a1.y : a2.y;
      for (int y = min_y+1; y < max_y; y++) {
        auto e = asteroids->find(Asteroid{a1.x, y});
        if (e != asteroids->end()) {
          num_blockers++;
        }
      }
    } else if (a1.y == a2.y) {
      int min_x = a1.x < a2.x ? a1.x : a2.x;
      int max_x = a1.x > a2.x ? a1.x : a2.x;
      for (int x = min_x+1; x < max_x; x++) {
        auto e = asteroids->find(Asteroid{x, a1.y});
        if (e != asteroids->end()) {
          num_blockers++;
        }
      }
    } else {
      int dx = a2.x - a1.x;
      int dy = a2.y - a1.y;
      int gcd = mgcd(dx,dy);
      dx /= gcd;
      dy /= gcd;
      int x = a1.x + dx;
      int y = a1.y + dy;
      while (x != a2.x && y != a2.y) {
        auto e = asteroids->find(Asteroid{x, y});
        if (e != asteroids->end()) {
          num_blockers++;
        }
        x += dx;
        y += dy;
      }
    }
    (*blockers)[ap] = num_blockers;
    ap = AsteroidPair{a2,a1};
    (*blockers)[ap] = num_blockers;
    return num_blockers;
  }
  auto part1() {
    int max =  std::numeric_limits<int>::min();
    for (auto const a1e : *asteroids) {
      auto a1 = a1e.first;
      int c = 0;
      for (auto const a2e : *asteroids) {
        auto a2 = a2e.first;
        if (a1 == a2) {
          continue;
        }
        if (num_blockers(a1,a2) == 0) {
          c++;
        }
      }
      if (max < c) {
        max = c;
        best = a1;
      }
    }
    return max;
  }

  double angle(Asteroid ast) {
    double a = atan2(double(ast.x - best.x), double(best.y - ast.y));
    while (a < 0) {
      a += 2 * PI;
    }
    return a;
  }

  auto part2(int num) {
    vector<AsteroidAngle> angles;
    for (auto const ae : *asteroids) {
      auto a = ae.first;
      if (a == best) {
        continue;
      }
      double an = angle(a);
      an += num_blockers(best, a) * 2 * PI;
      angles.push_back(AsteroidAngle{a, an});
    }
    sort(angles.begin(), angles.end());
    auto nth = angles[num-1].first;
    return nth.x * 100 + nth.y;
  }
};

void tests() {
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto g = new Game(inp, inp_len);
  auto p1 = g->part1();
  auto p2 = g->part2(200);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
