#include <stdio.h>
#include <iostream>
#include <vector>
#include <map>
#include <assert.h>
#include <sstream>
#include <numeric>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>

enum MoonField { X = 0, Y = 1, Z = 2, VX = 3, VY = 4, VZ = 5 };

typedef int* Moon;

string pp_moon(Moon m) {
  std::stringstream ss;
  ss << "pos=<x=" << m[X] << ", y=" << m[Y] << ", z=" << m[Z] <<
    ">,v vel=<x=" << m[VX] << ", y=" << m[VY] << ", z=" << m[VZ] << ">";
  return ss.str();
}

int energy(Moon m) {
  return (abs(m[X]) + abs(m[Y]) + abs(m[Z])) *
    (abs(m[VX]) + abs(m[VY]) + abs(m[VZ]));
}

string pp_moons(const vector<Moon> &moons) {
  std::stringstream ss;
  for(size_t i = 0; i < moons.size(); i++) {
    ss << pp_moon(moons[i]) << "\n";
  }
  return ss.str();
}

string axis_state(const vector<Moon> &moons, MoonField axis) {
  std::stringstream ss;
  for(size_t i = 0; i < moons.size(); i++) {
    ss << moons[i][axis] << ":" << moons[i][VX+axis] << "\n";
  }
  return ss.str();
}

void runstep(vector<Moon> &moons, MoonField axis) {
  for (size_t i = 0; i < moons.size(); i++) {
    for (size_t j = i + 1; j < moons.size(); j++) {
      if (moons[i][axis] > moons[j][axis]) {
        moons[i][VX+axis]--;
        moons[j][VX+axis]++;
      } else if (moons[i][axis] < moons[j][axis]) {
        moons[i][VX+axis]++;
        moons[j][VX+axis]--;
      }
    }
  }
  for (auto m : moons) {
    m[axis] += m[VX+axis];
  }
}

int part1(const vector<Moon> &c_moons, int steps) {
  vector<Moon> moons = c_moons;
  for (int step = 1; step <= steps; step++) {
    for (auto axis : {X, Y, Z}) {
      runstep(moons, axis);
    }
    //cout << "After step " << step << "\n" << pp_moons(moons) << "\n";
  }
  int e = 0;
  for (auto m : moons) {
    e += energy(m);
  }
  return e;
}

long gcd(long a, long b) {
  a = a < 0 ? -a : a;
  b = b < 0 ? -b : b;
  if (a > b) {
    swap(a,b);
  }
  while (a != 0) {
    long t = a;
    a = b % a;
    b = t;
  }
  return b;
}

long lcm(long a, long b) {
  return a * b / gcd(a, b);
}

long part2(vector<Moon> &c_moons) {
  vector<Moon> moons = c_moons;
  int cycle[3] = {-1,-1,-1};
  string state[3];
  for (auto axis : {X, Y, Z}) {
    state[axis] = axis_state(moons, axis);
    long steps = 0;
    while (cycle[axis] == -1) {
      steps++;
      runstep(moons, axis);
      if (state[axis] == axis_state(moons, axis)) {
        //printf("Found %d cycle at %ld\n", axis, steps);
        cycle[axis] = steps;
      }
    }
  }
  return lcm(lcm(cycle[0], cycle[1]), cycle[2]);
}

void tests() {
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto xyzs = ints(inp_len, inp);
  vector<Moon> moons;
  for (int i = 0; i < xyzs.size(); i += 3) {
    int* m = new int[6]{xyzs[i], xyzs[i+1], xyzs[i+2], 0, 0, 0};
    moons.push_back(m);
  }
  auto p1 = part1(moons, 1000);
  auto p2 = part2(moons);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
