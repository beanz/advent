#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include "../../lib/assert.hpp"
#include "../../lib/input.hpp"
#include "../../lib/intcode.hpp"

using namespace std;

long part1(const vector<long> prog) {
  auto ic = new IntCode(&prog, 1);
  auto out = ic->run_to_halt();
  return out[out.size()-1];
}

long part2(const vector<long> prog, long input) {
  auto ic = new IntCode(&prog, input);
  auto out = ic->run_to_halt();
  return out[0];
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

  AIEQ(op_arity(1), 3);
  AIEQ(op_arity(2), 3);
  AIEQ(op_arity(3), 1);
  AIEQ(op_arity(4), 1);
  AIEQ(op_arity(5), 2);
  AIEQ(op_arity(6), 2);
  AIEQ(op_arity(7), 3);
  AIEQ(op_arity(8), 3);
  AIEQ(op_arity(99), 0);

  AIEQ(part2(vector<long>{3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8}, 8), 1);
  AIEQ(part2(vector<long>{3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8}, 4), 0);
  AIEQ(part2(vector<long>{3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8}, 7), 1);
  AIEQ(part2(vector<long>{3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8}, 8), 0);
  AIEQ(part2(vector<long>{3, 3, 1108, -1, 8, 3, 4, 3, 99}, 8), 1);
  AIEQ(part2(vector<long>{3, 3, 1108, -1, 8, 3, 4, 3, 99}, 9), 0);
  AIEQ(part2(vector<long>{3, 3, 1107, -1, 8, 3, 4, 3, 99}, 7), 1);
  AIEQ(part2(vector<long>{3, 3, 1107, -1, 8, 3, 4, 3, 99}, 9), 0);
  AIEQ(part2(vector<long>{3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99,
          -1, 0, 1, 9}, 2), 1);
  AIEQ(part2(vector<long>{3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99,
          -1, 0, 1, 9}, 0), 0);
  AIEQ(part2(vector<long>{3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1}, 3),
       1);
  AIEQ(part2(vector<long>{3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1}, 0),
       0);
  AIEQ(part2(vector<long>{3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
          20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20,
          1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
          1, 46, 98, 99}, 5), 999);
  AIEQ(part2(vector<long>{3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
          20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20,
          1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
          1, 46, 98, 99}, 8), 1000);
  AIEQ(part2(vector<long>{3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
          20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20,
          1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
          1, 46, 98, 99}, 9), 1001);

  cout << "Part 1: " << part1(prog) << "\n";
  cout << "Part 2: " << part2(prog, 5) << "\n";
}
