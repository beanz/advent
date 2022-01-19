#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>
#include "intcode.hpp"

string pp_deque(const deque<long> v) {
  std::stringstream ss;
  for(size_t i = 0; i < v.size(); ++i) {
    if(i != 0)
      ss << ",";
    ss << v[i];
  }
  return ss.str();
}

string run(const vector<long>* prog, long input) {
  auto ic = new IntCode(prog, input);
  while (!ic->Done()) {
    ic->run();
  }
  return pp_deque(ic->outp);
}

string part1(const vector<long>* prog) {
  return run(prog, 1);
}

string part2(const vector<long>* prog) {
  return run(prog, 2);
}

void tests() {
  auto tp = vector<long>{109,1,204,-1,1001,100,1,100,1008,100,16,101,
                        1006,101,0,99};
  ASEQ(run(&tp,1),
       "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99");

  tp = vector<long>{1102,34915192,34915192,7,4,7,99,0};
  ASEQ(run(&tp,1), "1219070632396864");

  tp = vector<long>{104,1125899906842624,99};
  ASEQ(run(&tp,1), "1125899906842624");
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto prog = longs(inp_len, inp);
  auto p1 = part1(&prog);
  auto p2 = part2(&prog);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
