#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <functional>
#include <limits>
#include <assert.h>
#include <sstream>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

#define ASEQ(act,exp) { if (act != exp) { throw std::runtime_error("assert: " + act + " should equal " + exp); } }

int op_arity(int op) {
  const vector<int> op_arity_map = {0,3,3,1,1,2,2,3,3,1};
  if (op == 99) {
    return 0;
  }
  return op_arity_map[op];
}

typedef struct {
  long op;
  vector<long> param;
  vector<long> addr;
} Inst;

class IntCode {
  int ip;
  vector<long> prog;
  long base;
  bool done;
  std::function<int()> infn;
public:
  deque<long> outp;
  IntCode(const vector<long> &c_prog, std::function<int()> inf) : prog(c_prog) {
    ip = 0;
    done = false;
    base = 0;
    infn = inf;
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
        prog[inst->addr[0]] = infn();
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
      case 9:
        base += inst->param[0];
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
  long safe_prog(long i) {
    if (prog.size() <= i) {
      while (prog.size() <= i) {
        prog.push_back(0);
      }
      return prog[i];
    }
    return prog[i];
  }
  Inst* parse_inst() {
    long raw_op = prog[ip++];
    long op = raw_op%100;
    int arity = op_arity(op);
    vector<long> mode = {
      (raw_op/100)%10, (raw_op/1000)%10, (raw_op/10000)%10
    };
    vector<long> param;
    vector<long> addr;
    for (int i = 0; i < arity; i++) {
      switch (mode[i]) {
      case 1:
        param.push_back(safe_prog(ip));
        addr.push_back(-99);
        break;
      case 2:
        param.push_back(safe_prog(base+safe_prog(ip)));
        {
          long a = base+safe_prog(ip);
          addr.push_back(a);
          safe_prog(a);
        }
        break;
      default: // 0
        param.push_back(safe_prog(safe_prog(ip)));
        {
          int a2 = safe_prog(ip);
          addr.push_back(a2);
          safe_prog(a2);
        }
      }
      ip++;
    }
    return new Inst{op, param, addr};
  };
};

auto run(const vector<long> &prog, std::function<int()> inf, std::function<void(int,int,int)> outf) {
  auto ic = new IntCode(prog, inf);
  while (!ic->Done()) {
    ic->run();
    if (ic->outp.size() == 3) {
      auto x = ic->outp.front();
      ic->outp.pop_front();
      auto y = ic->outp.front();
      ic->outp.pop_front();
      auto t = ic->outp.front();
      ic->outp.pop_front();
      outf(x, y, t);
    }
  }
  return;
}

int part1(const vector<long> &prog_c) {
  vector<long> prog = prog_c;
  int blocks = 0;
  run(prog, []() { return 0; }, [&](int x, int y, int t) {
      if (t == 2) {
        blocks++;
      }
    });
  return blocks;
}

int part2(const vector<long> &prog_c) {
  vector<long> prog = prog_c;
  prog[0] = 2;
  int ball = 0;
  int paddle = 0;
  int score;
  run(prog,
      [&]() {
        if (ball < paddle) {
          return -1;
        } else if (ball > paddle) {
          return 1;
        }
        return 0;
      },
      [&](int x, int y, int t) {
      if (x == -1 && y == 0) {
        score = t;
      } else if (t == 3) {
        paddle = x;
      } else if (t == 4) {
        ball = x;
      }
    });
  return score;
}

int main() {
  vector<long> prog;
  long x;
  while ((cin >> x) && cin.ignore()) {
    prog.push_back(x);
  }
  cout << "Part 1: " << part1(prog) << "\n";
  cout << "Part 2: " << part2(prog) << "\n";
}
