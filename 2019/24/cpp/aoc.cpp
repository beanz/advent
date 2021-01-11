#include <stdio.h>
#include <iostream>
#include <sstream>
#include <set>
#include <map>
#include <assert.h>
#include "input.hpp"
#include "assert.hpp"

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

string pp1(int n) {
  string s = "";
  int i = 1;
  for (int y = 0; y < 5; y++) {
    for (int x = 0; x < 5; x++) {
      if ((n&i) != 0) {
        s += "#";
      } else {
        s += ".";
      }
      i <<= 1;
    }
    s += "\n";
  }
  return s;
}

bool bug(int n, int x, int y) {
  if (y < 0 || y >= 5 || x < 0 || x >= 5) {
    return false;
  }
  int a = y*5+x;
  return (n & (1 << a)) != 0;
}

bool life(int n, int x, int y) {
  int c = 0;
  if (bug(n, x, y-1)) c++;
  if (bug(n, x-1, y)) c++;
  if (bug(n, x+1, y)) c++;
  if (bug(n, x, y+1)) c++;
  return c == 1 || (!bug(n, x, y) && c == 2);
}

int part1(const vector<string> &lines) {
  int i = 1;
  int n = 0;
  for (int y = 0; y < 5; y++) {
    for (int x = 0; x < 5; x++) {
      if (lines[y][x] == '#') {
        n += i;
      }
      i <<= 1;
    }
  }
  //printf("%s\n", pp1(n).c_str());
  set<int> seen;
  seen.insert(n);
  while (true) {
    int next = 0;
    int i = 1;
    for (int y = 0; y < 5; y++) {
      for (int x = 0; x < 5; x++) {
        if (life(n, x, y)) {
          next += i;
        }
        i <<= 1;
      }
    }
    if (seen.find(next) != seen.end()) {
      return next;
    }
    seen.insert(next);
    n = next;
  }
  return -1;
}

typedef map<int,int> Map;

bool bug2(const Map &m, int d, int x, int y) {
  if (y < 0 || y >= 5 || x < 0 || x >= 5) {
    return false;
  }
  auto it = m.find(d);
  if (it == m.end()) {
    return false;
  }
  int a = y*5+x;
  return (it->second & (1 << a)) != 0;
}

bool life2(const Map &m, int d, int x, int y) {
  int c = 0;

  // neighbour(s) above
  if (y == 0) {
    if (bug2(m, d-1, 2, 1)) {
      c++;
    }
  } else if (y == 3 && x == 2) {
    for (int i = 0; i < 5; i++) {
      if (bug2(m, d+1, i, 4)) {
        c++;
      }
    }
  } else {
    if (bug2(m, d, x, y-1)) {
      c++;
    }
  }

  // neighbour(s) below
  if (y == 4) {
    if (bug2(m, d-1, 2, 3)) {
      c++;
    }
  } else if (y == 1 && x == 2) {
    for (int i = 0; i < 5; i++) {
      if (bug2(m, d+1, i, 0)) {
        c++;
      }
    }
  } else {
    if (bug2(m, d, x, y+1)) {
      c++;
    }
  }

  // neighbour(s) left
  if (x == 0) {
    if (bug2(m, d-1, 1, 2)) {
      c++;
    }
  } else if (x == 3 && y == 2) {
    for (int i = 0; i < 5; i++) {
      if (bug2(m, d+1, 4, i)) {
        c++;
      }
    }
  } else {
    if (bug2(m, d, x-1, y)) {
      c++;
    }
  }

  // neighbour(s) right
  if (x == 4) {
    if (bug2(m, d-1, 3, 2)) {
      c++;
    }
  } else if (x == 1 && y == 2) {
    for (int i = 0; i < 5; i++) {
      if (bug2(m, d+1, 0, i)) {
        c++;
      }
    }
  } else {
    if (bug2(m, d, x+1, y)) {
      c++;
    }
  }
  // printf("life2 %d %d,%d %d %d\n", d, x, y, c, bug2(m, d, x, y));

  return c == 1 || (!bug2(m, d, x, y) && c == 2);
}

string pp2(const Map &m) {
  stringstream ss;
  for (auto it = m.begin(); it != m.end(); it++) {
    ss << "Depth " << it->first << "\n";
    ss << pp1(it->second) << "\n";
  }
  return ss.str();
}

int count(const Map &m) {
  int c = 0;
  for (auto it = m.begin(); it != m.end(); it++) {
    int i = 1;
    for (int y = 0; y < 5; y++) {
      for (int x = 0; x < 5; x++) {
        if ((it->second&i) != 0) {
          c++;
        }
        i <<= 1;
      }
    }
  }
  return c;
}

int part2(const vector<string> &lines, int min) {
  int i = 1;
  int n = 0;
  for (int y = 0; y < 5; y++) {
    for (int x = 0; x < 5; x++) {
      if (lines[y][x] == '#') {
        n += i;
      }
      i <<= 1;
    }
  }
  Map m;
  m.insert(make_pair(0, n));
  for (int t = 0; t < min; t++) {
    // printf("%s\n", pp2(m).c_str());
    Map nextM;
    int minD = m.begin()->first - 1;
    int maxD = m.rbegin()->first + 1;
    // printf("%d %d .. %d\n", t, minD, maxD);
    for (int depth = minD; depth <= maxD; depth++) {
      int next = 0;
      for (int y = 0; y < 5; y++) {
        for (int x = 0; x < 5; x++) {
          if (x == 2 && y == 2) {
            continue;
          }
          if (life2(m, depth, x, y)) {
            next += (1 << (y*5 + x));
          }
        }
      }
      if ((depth == minD || depth == maxD) && next == 0) {
        // skip
      } else {
        nextM.insert(make_pair(depth, next));
      }
    }
    m.swap(nextM);
  }
  // printf("%s\n", pp2(m).c_str());
  return count(m);
}

int main(int argc, char *argv[]) {
  string file = "input.txt";
  if (argc > 1) {
    file = argv[1];
  }
  vector<string> lines = readlines(file);
  if (getenv("AoC_TEST")) {
    AIEQ(part1(readlines("test.txt")), 2129920);
    AIEQ(part1(readlines("input.txt")), 6520863);
    AIEQ(part2(readlines("test.txt"), 1), 27);
    AIEQ(part2(readlines("test.txt"), 10), 99);
    AIEQ(part2(readlines("input.txt"), 1), 21);
    AIEQ(part2(readlines("input.txt"), 200), 1970);
  }
  cout << "Part 1: " << part1(lines) << "\n";
  cout << "Part 2: " << part2(lines, 200) << "\n";
}
