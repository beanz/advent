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

int runscript(vector<long> prog, string script) {
  auto ic = new IntCode(&prog, script);
  auto out = ic->run_to_halt();
  string s;
  for (auto ch : out) {
    if (ch > 127) {
      return ch;
    }
    s += (char)ch;
  }
  printf("%s\n", s.c_str());
  return -1;
}

int part1(vector<long> prog) {
  // (!C && D) || !A
  return runscript(prog, "NOT C J\nAND D J\nNOT A T\nOR T J\nWALK\n");
}

int part2(vector<long> prog) {
  // (!A || ( (!B || !C) && H ) ) && D
  return  runscript(prog,
     "NOT B T\nNOT C J\nOR J T\nAND H T\nNOT A J\nOR T J\nAND D J\nRUN\n");
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
