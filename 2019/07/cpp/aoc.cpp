#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <algorithm>
#include <limits>
#include <assert.h>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

int op_arity(int op) {
  const vector<int> op_arity_map = {0,3,3,1,1,2,2,3,3};
  if (op == 99) {
    return 0;
  }
  return op_arity_map[op];
}

typedef struct {
  int op;
  vector<int> param;
  vector<int> addr;
} Inst;

class IntCode {
  int ip;
  vector<int> prog;
  bool done;
public:
  deque<int> inp, outp;
  IntCode(const vector<int>* c_prog, int phase) : prog(*c_prog) {
    ip = 0;
    inp.push_back(phase);
    done = false;
  }

  bool Done() { return done; }

  auto run() {
    int l = (int)prog.size();
    while (ip < l) {
      auto inst = parse_inst();
      switch (inst->op) {
      case 1:
        prog[inst->addr[2]] = inst->param[0] + inst->param[1];
        break;
      case 2:
        prog[inst->addr[2]] = inst->param[0] * inst->param[1];
        break;
      case 3:
        if (inp.size() == 0) {
          prog[inst->addr[0]] = 0;
        } else {
          prog[inst->addr[0]] = inp.front();
          inp.pop_front();
        }
        break;
      case 4:
        outp.push_back(inst->param[0]);
        return 0;
      case 5:
        if (inst->param[0] != 0) {
          ip = inst->param[1];
        }
        break;
      case 6:
        if (inst->param[0] == 0) {
          ip = inst->param[1];
        }
        break;
      case 7:
        if (inst->param[0] < inst->param[1]) {
          prog[inst->addr[2]] = 1;
        } else {
          prog[inst->addr[2]] = 0;
        }
        break;
      case 8:
        if (inst->param[0] == inst->param[1]) {
          prog[inst->addr[2]] = 1;
        } else {
          prog[inst->addr[2]] = 0;
        }
        break;
      case 99:
        delete inst;
        done = true;
        return 1;
      default:
        delete inst;
        done = true;
        return -1;
      }
      delete inst;
    }
    done = true;
    return -2;
  }

private:
  Inst* parse_inst() {
    int raw_op = prog[ip++];
    int op = raw_op%100;
    int arity = op_arity(op);
    vector<bool> immediate = {
      (raw_op/100)%10 == 1, (raw_op/1000)%10 == 1, (raw_op/10000)%10 == 1
    };
    vector<int> param;
    vector<int> addr;
    for (int i = 0; i < arity; i++) {
      if (immediate[i]) {
        param.push_back(prog[ip]);
        addr.push_back(-99);
      } else {
        param.push_back(prog[prog[ip]]);
        addr.push_back(prog[ip]);
      }
      ip++;
    }
    return new Inst{op, param, addr};
  };
};

int tryPhase(const vector<int>* prog, int* phase) {
  IntCode* u[5];
  for (int i = 0; i<5; i++) {
    u[i] = new IntCode(prog, phase[i]);
  }
  int done = 0;
  int last = 0;
  int out = 0;
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

int run(const vector<int>* prog, int minPhase) {
  int phase[5] = { minPhase, minPhase+1, minPhase+2, minPhase+3, minPhase+4 };
  std::sort(phase, phase+5);
  int max =  std::numeric_limits<int>::min();
  do {
    int thrust = tryPhase(prog, phase);
    if (thrust > max) {
      max = thrust;
    }
  } while (next_permutation(phase, phase+5));
  return max;
}

int part1(const vector<int>* prog) {
  return run(prog, 0);
}

int part2(const vector<int>* prog) {
  return run(prog, 5);
}

int main() {
  vector<int> prog;
  int x;
  while ((cin >> x) && cin.ignore()) {
    prog.push_back(x);
  }

  auto tp = vector<int>{3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0};
  AIEQ(part1(&tp), 43210);
  tp = vector<int>{3,23,3,24,1002,24,10,24,1002,23,-1,23,
                   101,5,23,23,1,24,23,23,4,23,99,0,0};
  AIEQ(part1(&tp), 54321);
  tp = vector<int>{3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
                   1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0};
  AIEQ(part1(&tp), 65210);

  tp = vector<int>{3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
                   27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5};
  AIEQ(part2(&tp), 139629729);
  tp = vector<int>{3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,
                   55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,
                   1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,
                   0,0,0,0,10};
  AIEQ(part2(&tp), 18216);

  cout << "Part 1: " << part1(&prog) << "\n";
  cout << "Part 2: " << part2(&prog) << "\n";
}
