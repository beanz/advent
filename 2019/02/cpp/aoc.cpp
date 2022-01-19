#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>

void pp(int ip, const vector<int> &prog) {
  cout << ip << ": ";
  for (int i = 0; i<(int)prog.size(); i++) {
    cout << prog[i] << " ";
  }
  cout << endl;
}

int part1(const vector<int> &prog_c) {
  vector<int> prog = prog_c;
  int ip = 0;
  int l = (int)prog.size();
  while (ip < l) {
    int op = prog[ip++];
    int i1, i2, o;
    switch (op) {
    case 1:
      if (ip+2 >= l) {
        return -1;
      }
      i1 = prog[ip++];
      i2 = prog[ip++];
      o = prog[ip++];
      prog[o] = prog[i1] + prog[i2];
      break;
    case 2:
      if (ip+2 >= l) {
        return -2;
      }
      i1 = prog[ip++];
      i2 = prog[ip++];
      o = prog[ip++];
      prog[o] = prog[i1] * prog[i2];
      break;
    case 99:
      return prog[0];
    default:
      return -3;
    }
  }
  return -4;
}

int part2(const vector<int> &prog_c) {
  for (int input = 0; input <= 9999; input++) {
    vector<int> prog = prog_c;
    prog[1] = input / 100;
    prog[2] = input % 100;
    int res = part1(prog);
    if (res == 19690720) {
      return input;
    }
  }
  return -1;
}

void tests() {
  AIEQ(part1(vector<int>{1,0,0,0,99}), 2);
  AIEQ(part1(vector<int>{1,0,0,0,99}), 2);
  AIEQ(part1(vector<int>{1,1,1,4,99,5,6,0,99}), 30);
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  vector<int> prog = ints(inp_len, inp);
  prog[1] = 12;
  prog[2] = 2;
  int p1 = part1(prog);
  int p2 = part2(prog);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
