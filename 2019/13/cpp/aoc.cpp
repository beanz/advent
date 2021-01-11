#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <limits>
#include <assert.h>
#include <sstream>
#include "assert.hpp"
#include "input.hpp"
#include "intcode.hpp"
#include "point.hpp"

using namespace std;

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

int main(int argc, char *argv[]) {
  string file = "input.txt";
  if (argc > 1) {
    file = argv[1];
  }
  vector<long> prog = readints(file);
  if (getenv("AoC_TEST")) {
    //AIEQ((new Donut(readlines("test1a.txt")))->part1(), 23);
  }

  cout << "Part 1: " << part1(prog) << "\n";
  cout << "Part 2: " << part2(prog) << "\n";
}
