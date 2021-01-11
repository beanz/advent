#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>
#include "input.hpp"
#include "intcode.hpp"
#include "assert.hpp"

using namespace std;

auto part1(vector<long> prog) {
  vector<IntCode*> ic;
  for (int i = 0; i < 50; i++) {
    ic.push_back(new IntCode(&prog, (long)i));
  }
  while (true) {
    for (int i = 0; i < 50; i++) {
      auto rc = ic[i]->run();
      if (rc == 0) {
        auto out = ic[i]->output(3);
        if (out.size() == 3) {
          auto addr = out[0];
          auto x = out[1];
          auto y = out[2];
          if (addr == 255) {
            return y;
          } else if (addr < 50) {
            ic[addr]->inp.push_back(x);
            ic[addr]->inp.push_back(y);
          }
        }
      } else if (rc == 2) {
        ic[i]->inp.push_back(-1);
      }
    }
  }
}

auto part2(vector<long> prog) {
  vector<IntCode*> ic;
  for (int i = 0; i < 50; i++) {
    ic.push_back(new IntCode(&prog, (long)i));
  }
  long natX = 0;
  long natY = 0;
  long last = -1;
  while (true) {
    int idle = 0;
    for (int i = 0; i < 50; i++) {
      auto rc = ic[i]->run();
      if (rc == 0) {
        auto out = ic[i]->output(3);
        if (out.size() == 3) {
          auto addr = out[0];
          auto x = out[1];
          auto y = out[2];
          if (addr == 255) {
            natX = x;
            natY = y;
          } else if (addr < 50) {
            ic[addr]->inp.push_back(x);
            ic[addr]->inp.push_back(y);
          }
        }
      } else if (rc == 2) {
        idle++;
        ic[i]->inp.push_back(-1);
      }
    }
    if (idle == 50) {
      if (last == natY) {
        return natY;
      }
      last = natY;
      ic[0]->inp.push_back(natX);
      ic[0]->inp.push_back(natY);
    }
  }
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
