#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>
#include "../../lib/input.hpp"
#include "../../lib/intcode.hpp"
#include "../../lib/assert.hpp"

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

class Beam {
  vector<long> prog;
  int divisor;
  int ratio1;
  int ratio2;
public:
  int size;

  Beam(const vector<long>* c_prog): prog(*c_prog) {
    divisor = 1;
    ratio1 = 1;
    ratio2 = 2;
    size = 100 - 1;
  }
  bool inBeam(int x, int y) {
    deque<long> input;
    input.push_back(x);
    input.push_back(y);
    auto ic = new IntCode(&prog, input);
    auto res = ic->run_to_single_output();
    return res == 1;
  }
  auto part1() {
    int c = 0;
    int first = -1;
    int last = -1;
    for (int y = 0; y < 50; y++) {
      first = -1;
      last = -1;
      for (int x = 0; x < 50; x++) {
        if (this->inBeam(x, y)) {
          if (first == -1) {
            first = x;
          }
          last = x;
          c++;
        }
      }
    }
    this->ratio1 = first;
    this->ratio2 = last;
    this->divisor = 49;
    return c;
  }

  auto squareFits(int x, int y) {
    return this->inBeam(x, y) &&
      this->inBeam(x+this->size, y) &&
      this->inBeam(x, y+this->size);
  }

  auto squareFitsY(int y) {
    int min = (y * this->ratio1 / this->divisor);
    int max = (y * this->ratio2 / this->divisor);
    for (int x = min; x <= max; x++) {
      if (this->squareFits(x, y)) {
        return x;
      }
    }
    return 0;
  }

  auto part2() {
    int upper = 1;
    while (this->squareFitsY(upper) == 0) {
      upper *= 2;
    }
    int lower = upper / 2;
    while (true) {
      int mid = lower + (upper-lower) / 2;
      if (mid == lower) {
        break;
      }
      if (this->squareFitsY(mid) > 0) {
        upper = mid;
      } else {
        lower = mid;
      }
    }
    int x;
    int y;
    for (y = lower; y < lower + 5; y++) {
      x = this->squareFitsY(y);
      if (x > 0) {
        break;
      }
    }
    return x*10000 + y;
  }
};

int main(int argc, char *argv[]) {
  string file = "input.txt";
  if (argc > 1) {
    file = argv[1];
  }
  vector<long> prog = readints(file);
  if (getenv("AoC_TEST")) {
    //AIEQ((new Donut(readlines("test1a.txt")))->part1(), 23);
  }
  auto beam = new Beam(&prog);
  cout << "Part 1: " << beam->part1() << "\n";
  cout << "Part 2: " << beam->part2() << "\n";
}