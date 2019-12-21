#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include "../../lib/input.hpp"
#include "../../lib/intcode.hpp"
#include "../../lib/assert.hpp"

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

int part1(const vector<long> &inp) {
  return 1;
}

int part2(const vector<long> &inp) {
  return 2;
}

int main(int argc, char *argv[]) {
  string file = "input.txt";
  if (argc > 1) {
    file = argv[1];
  }
  vector<long> prog = readints(file);
  //vector<string> lines = readlines(file);
  if (getenv("AoC_TEST")) {
    //AIEQ((new Donut(readlines("test1a.txt")))->part1(), 23);
  }
  cout << "Part 1: " << part1(prog) << "\n";
  cout << "Part 2: " << part2(prog) << "\n";
}
