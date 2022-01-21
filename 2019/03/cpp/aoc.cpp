#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include <map>
#include <string>
#include <limits>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>

typedef pair<int, int> point;
typedef map<point,int> path;
typedef pair<char,int> wire_move;

auto find_path(unsigned char *s, size_t *i, size_t len) {
  auto p = new path;

  int x = 0;
  int y = 0;
  int steps = 0;
  while (*i < len) {
    int dx = 0;
    int dy = 0;
    switch (s[*i]) {
      case 'U':
        dy--;
        break;
      case 'D':
        dy++;
        break;
      case 'L':
        dx--;
        break;
      case 'R':
        dx++;
        break;
      default:
        printf("invalid move %d %zu\n", s[*i], *i);
        exit(1);
    }
    (*i)++;
    auto moves = scanUint(s, i, len);
    for (auto j = 0; j < moves; j++) {
      x += dx;
      y += dy;
      steps++;
      p->insert(std::make_pair(std::make_pair(x, y), steps));
    }
    if (s[*i] == '\n') {
      (*i)++;
      break;
    }
    (*i)++;
  }
  return p;
}

auto calc(unsigned char *inp, size_t len) {
  size_t i = 0;
  auto p1 = find_path(inp, &i, len);
  auto p2 = find_path(inp, &i, len);
  int steps = std::numeric_limits<int>::max();
  int dist = std::numeric_limits<int>::max();
  for (auto p : *p1) {
    auto itr = p2->find(std::make_pair(p.first.first, p.first.second));
    if (itr != p2->end()) {
      int s = p.second + itr->second;
      if (s < steps) {
        steps = s;
      }
      int d = abs(p.first.first) + abs(p.first.second);
      if (d < dist) {
        dist = d;
      }
    }
  }
  return std::make_pair(dist, steps);
}

void tests() {
  AIEQ(calc((unsigned char*)"R8,U5,L5,D3\nU7,R6,D4,L4\n", 9999).first, 6);
  AIEQ(calc((unsigned char*)"R8,U5,L5,D3\nU7,R6,D4,L4\n", 9999).second, 30);
  AIEQ(calc((unsigned char*)"R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7\n", 9999).first, 135 );
  AIEQ(calc((unsigned char*)"R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7\n", 9999).second, 410 );
  AIEQ(calc((unsigned char*)"R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83\n", 9999).first, 159);
  AIEQ(calc((unsigned char*)"R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83\n", 9999).second, 610);
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto res = calc(inp, inp_len);
  if (!is_bench) {
    cout << "Part 1: " << res.first << "\n";
    cout << "Part 2: " << res.second << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
