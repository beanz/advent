#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <limits>
#include <assert.h>
#include <sstream>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>
#include "intcode.hpp"
#include "point.hpp"

int part1(const vector<long> &prog_c) {
  vector<long> prog = prog_c;
  int blocks = 0;
  auto ic = new IntCode(&prog);
  ic->run_with_callbacks([]() { return 0; }, [&](vector<long> out) {
      if (out[2] == 2) {
        blocks++;
      }
    }, 3);
  return blocks;
}

int part2(const vector<long> &prog_c) {
  vector<long> prog = prog_c;
  prog[0] = 2;
  int ball = 0;
  int paddle = 0;
  int score;
  auto ic = new IntCode(&prog);
  ic->run_with_callbacks(
      [&]() {
        if (ball < paddle) {
          return -1;
        } else if (ball > paddle) {
          return 1;
        }
        return 0;
      },
      [&](vector<long>out) {
        int x = out[0]; int y = out[1]; int t = out[2];
        if (x == -1 && y == 0) {
          score = t;
        } else if (t == 3) {
          paddle = x;
        } else if (t == 4) {
          ball = x;
        }
      }, 3);
  return score;
}

void tests() {
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto prog = longs(inp_len, inp);
  auto p1 = part1(prog);
  auto p2 = part2(prog);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
