#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>
#include "intcode.hpp"

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

struct Point {
  int x, y;
  bool operator<(const Point& b) const {
    return x < b.x || (x == b.x && y < b.y);
  }
};

class BoundingBox {
  Point min, max;
public:
  BoundingBox() {
    max = Point{numeric_limits<int>::min(), numeric_limits<int>::min()};
    min = Point{numeric_limits<int>::max(), numeric_limits<int>::max()};
  }
  void Add(Point p) {
    if (p.x > max.x) {
      max.x = p.x;
    }
    if (p.x < min.x) {
      min.x = p.x;
    }
    if (p.y > max.y) {
      max.y = p.y;
    }
    if (p.y < min.y) {
      min.y = p.y;
    }
  }
  int MinX() {
    return min.x;
  };
  int MaxX() {
    return max.x;
  };
  int MinY() {
    return min.y;
  };
  int MaxY() {
    return max.y;
  };
};

class Direction {
  int x, y;
public:
  Direction(int px, int py) {
    x = px;
    y = py;
  }
  auto X() { return x; }
  auto Y() { return y; }
  auto CW() {
    if (x == 0 && y == -1) {
      return new Direction(1,0);
    } else if (x == 1 && y == 0) {
      return new Direction(0,1);
    } else if (x == 0 && y == 1) {
      return new Direction(-1,0);
    } else {
      return new Direction(0,-1);
    }
  }
  auto CCW() {
    if (x == 0 && y == -1) {
      return new Direction(-1,0);
    } else if (x == 1 && y == 0) {
      return new Direction(0,-1);
    } else if (x == 0 && y == 1) {
      return new Direction(1,0);
    } else {
      return new Direction(0,1);
    }
  }
  auto Right() {
    return CW();
  }
  auto Left() {
    return CCW();
  }
  auto ToPointer() {
    if (x == 0 && y == -1) {
      return "^";
    } else if (x == 1 && y == 0) {
      return ">";
    } else if (x == 0 && y == 1) {
      return "v";
    } else {
      return "<";
    }
  }
};

typedef map<Point,bool> Map;

class Scaffold {
  Map *m;
  BoundingBox *bb;
public:
  Point pos;
  Point bot;
  Direction* dir;

  Scaffold() {
    m = new Map();
    bb = new BoundingBox();
    pos = Point{0,0};
    bot = Point{-1,-1};
    dir = new Direction(0,-1);
  }
  auto AddPipe(Point pos) {
    (*m)[pos] = true;
  }
  auto IsPipe(Point p) {
    auto e = m->find(p);
    if (e != m->end()) {
      return e->second;
    }
    return false;
  }
  auto IsPipe(int x, int y) {
    return IsPipe(Point{x, y});
  }
  auto BB() {
    return bb;
  }
  auto pp() {
    std::stringstream ss;
    for (auto y = bb->MinY(); y <= bb->MaxY(); y++) {
      for (auto x = bb->MinX(); x <= bb->MaxX(); x++) {
        if (bot.x == x && bot.y == y) {
          ss << dir->ToPointer();
        } else if (IsPipe(x, y)) {
            ss << "#";
        } else {
          ss << ".";
        }
      }
      ss << "\n";
    }
    return ss.str();
  }

  auto alignmentSum() {
    int ans = 0;
    for (auto y = bb->MinY(); y <= bb->MaxY(); y++) {
      for (auto x = bb->MinX(); x <= bb->MaxX(); x++) {
        if (IsPipe(x, y) &&
            IsPipe(x, y-1) &&
            IsPipe(x, y+1) &&
            IsPipe(x-1, y) &&
            IsPipe(x+1, y)) {
          ans += x * y;
        }
      }
    }
    return ans;
  }
};

auto part1(const vector<long>* prog) {
  auto ic = new IntCode(prog, 0);
  auto outp = ic->run_to_halt();
  auto scaff = new Scaffold();
  for (auto i = 0; i < outp.size(); i++) {
    switch (outp[i]) {
    case 10:
      scaff->pos.x = 0;
      scaff->pos.y++;
      break;
    case 35:
      scaff->AddPipe(scaff->pos);
      scaff->pos.x++;
      break;
    case 94:
      scaff->AddPipe(scaff->pos);
      scaff->bot = Point{scaff->pos.x, scaff->pos.y};
      scaff->pos.x++;
      break;
    default:
      scaff->pos.x++;
    }
    scaff->BB()->Add(scaff->pos);
  }
  return scaff;
}
void findAndReplace(string& s, string f, string r) {
  size_t pos = s.find(f);
  while (pos != string::npos) {
    s.replace(pos, f.size(), r);
    pos = s.find(f, pos+r.size());
  }
}

auto nextFunc(string path, int off, string ch) {
  int shortest = numeric_limits<int>::max();
  string fun;
  for (int i = 1; i < 22; i++) {
    string sub = path.substr(off, i);
    auto t = path;
    findAndReplace(t, sub, ch);
    if (shortest > t.size()) {
      shortest = t.size();
      fun = sub;
    }
  }
  fun.erase(fun.find_last_not_of(",RL") + 1);
  return fun;
}

auto part2(const vector<long> &prog, Scaffold* scaff) {
  auto pos = scaff->bot;
  auto dir = scaff->dir;
  vector<long> path;
  while (true) {
    auto np = Point{pos.x + dir->X(), pos.y + dir->Y()};
    if (scaff->IsPipe(np)) {
      pos = np;
      if (path.size() > 0 && path.back() > 0) {
        path.back()++;
      } else {
        path.push_back(1);
      }
    } else {
      auto left = dir->Left();
      auto np = Point{pos.x + left->X(), pos.y + left->Y()};
      if (scaff->IsPipe(np)) {
        dir = left;
        path.push_back(-1); // -1 == LEFT
      } else {
        auto right = dir->Right();
        auto np = Point{pos.x + right->X(), pos.y + right->Y()};
        if (scaff->IsPipe(np)) {
          dir = right;
          path.push_back(-2); // -2 == RIGHT
        } else {
          break;
        }
      }
    }
  }
  //printf("%s\n", pp_vector(path).c_str());
  std::stringstream ss;
  bool first = true;
  for (const auto &m : path) {
    if (!first) {
      ss << ",";
    }
    if (m > 0) {
      ss << m;
    } else if (m == -1) {
      ss << "L";
    } else if (m == -2) {
      ss << "R";
    }
    first = false;
  }
  auto pathStr = ss.str();
  //printf("P: %s\n", pathStr.c_str());
  auto funA = nextFunc(pathStr, 0, "A");
  //printf("A: %s\n", funA.c_str());
  findAndReplace(pathStr, funA, "A");
  auto off = 0;
  while (pathStr[off] == 'A' || pathStr[off] == ',') {
    off++;
  }
  auto funB = nextFunc(pathStr, off, "B");
  //printf("B: %s\n", funB.c_str());
  findAndReplace(pathStr, funB, "B");
  off = 0;
  while (pathStr[off] == 'A' || pathStr[off] == 'B' || pathStr[off] == ',') {
    off++;
  }
  auto funC = nextFunc(pathStr, off, "C");
  //printf("C: %s\n", funC.c_str());
  findAndReplace(pathStr, funC, "C");
  auto funM = pathStr;
  //printf("M: %s\n", pathStr.c_str());
  string input = "";
  string format[] = { funM, funA, funB, funC, "n"};
  for (string s : format) {
    input += s + "\n";
  }
  //printf("%s\n", pp_deque(inp).c_str());
  vector<long> prog2 = prog;
  prog2[0] = 2;
  auto ic = new IntCode(&prog2, input);
  auto outp = ic->run_to_halt();
  return outp.back();
}

void tests() {
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto prog = longs(inp_len, inp);
  auto scaff = part1(&prog);
  auto p1 = scaff->alignmentSum();
  auto p2 = part2(prog, scaff);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
