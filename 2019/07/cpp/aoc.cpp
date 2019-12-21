#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <algorithm>
#include <limits>
#include <assert.h>
#include "../../lib/assert.hpp"
#include "../../lib/input.hpp"
#include "../../lib/intcode.hpp"

using namespace std;

long tryPhase(const vector<long>* prog, long* phase) {
  IntCode* u[5];
  for (int i = 0; i<5; i++) {
    u[i] = new IntCode(prog, phase[i]);
  }
  int done = 0;
  long last = 0;
  long out = 0;
  bool first = true;
  for (;done != 5;) {
    done = 0;
    for (int i = 0; i<5; i++) {
      if (u[i]->Done()) {
        done++;
      } else {
        if (!first) {
          u[i]->inp.push_back(out);
        }
        int rc = u[i]->run();
        if (u[i]->outp.size() != 0) {
          out = u[i]->outp.front();
          u[i]->outp.pop_front();
          last = out;
        }
        if (rc == 1 || rc < 0) {
          done++;
        }
      }
      first = false;
    }
  }
  return last;
}

long run(const vector<long>* prog, long minPhase) {
  long phase[5] = { minPhase, minPhase+1, minPhase+2, minPhase+3, minPhase+4 };
  std::sort(phase, phase+5);
  long max =  std::numeric_limits<long>::min();
  do {
    long thrust = tryPhase(prog, phase);
    if (thrust > max) {
      max = thrust;
    }
  } while (next_permutation(phase, phase+5));
  return max;
}

long part1(const vector<long>* prog) {
  return run(prog, 0);
}

long part2(const vector<long>* prog) {
  return run(prog, 5);
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

  auto tp = vector<long>{3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0};
  AIEQ(part1(&tp), 43210);
  tp = vector<long>{3,23,3,24,1002,24,10,24,1002,23,-1,23,
                   101,5,23,23,1,24,23,23,4,23,99,0,0};
  AIEQ(part1(&tp), 54321);
  tp = vector<long>{3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
                   1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0};
  AIEQ(part1(&tp), 65210);

  tp = vector<long>{3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
                   27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5};
  AIEQ(part2(&tp), 139629729);
  tp = vector<long>{3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,
                   55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,
                   1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,
                   0,0,0,0,10};
  AIEQ(part2(&tp), 18216);

  cout << "Part 1: " << part1(&prog) << "\n";
  cout << "Part 2: " << part2(&prog) << "\n";
}
