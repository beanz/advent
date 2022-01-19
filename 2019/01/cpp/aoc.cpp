#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>

int fuel(int m) {
  return m/3 - 2;
}

int fuelr(int m) {
  int s = 0;
  while (true) {
    int f = fuel(m);
    if (f <= 0) {
      break;
    }
    s += f;
    m = f;
  }
  return s;
}

int part1(const vector<int> &masses) {
  int s = 0;
  for (unsigned int i = 0; i < masses.size(); i++) {
    s += fuel(masses[i]);
  }
  return s;
}

int part2(const vector<int> &masses) {
  int s = 0;
  for (unsigned int i = 0; i < masses.size(); i++) {
    s += fuelr(masses[i]);
  }
  return s;
}

void tests() {
  AIEQ(part1(vector<int>{12}), 2);
  AIEQ(part1(vector<int>{14}), 2);
  AIEQ(part1(vector<int>{1969}), 654);
  AIEQ(part1(vector<int>{100756}), 33583);
  AIEQ(part1(vector<int>{12,14,1969,100756}), 34241);

  AIEQ(part2(vector<int>{12}), 2);
  AIEQ(part2(vector<int>{14}), 2);
  AIEQ(part2(vector<int>{1969}), 966);
  AIEQ(part2(vector<int>{100756}), 50346);
  AIEQ(part2(vector<int>{12,14,1969,100756}), 51316);
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  vector<int> masses = ints(inp_len, inp);
  auto p1 = part1(masses);
  auto p2 = part2(masses);

  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
