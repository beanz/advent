#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

#define ASEQ(act,exp) { if (act != exp) { throw std::runtime_error("assert: " + act + " should equal " + exp); } }

string pp_deque(const deque<long> v) {
  std::stringstream ss;
  for(size_t i = 0; i < v.size(); ++i) {
    if(i != 0)
      ss << ",";
    ss << v[i];
  }
  return ss.str();
}

string pp_vector(const vector<long> v) {
  std::stringstream ss;
  for(size_t i = 0; i < v.size(); ++i) {
    if(i != 0)
      ss << " ";
    ss << v[i];
  }
  return ss.str();
}

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
public:
  deque<long> inp, outp;
  IntCode(const vector<long>* c_prog, deque<long> input)
    : inp(input), prog(*c_prog)
  {
    ip = 0;
    done = false;
    base = 0;
  }

  IntCode(const vector<long>* c_prog, long input)
    : prog(*c_prog)
  {
    ip = 0;
    done = false;
    base = 0;
    vector<long> inp;
    inp.push_back(input);
  }

  IntCode* CloneWithInput(long input) {
    const vector<long> p = this->prog;
    auto ic = new IntCode(&p, input);
    ic->done = this->done;
    ic->base = this->base;
    ic->ip = this->ip;
    return ic;
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
  deque<long> run_to_halt() {
    while (!this->Done()) {
      this->run();
    }
    return this->outp;
  }

  long run_to_single_output() {
    while (!this->Done()) {
      this->run();
      if (this->outp.size() == 1) {
        return this->outp[0];
      }
    }
    return -1;
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


class Beam {
  vector<long> prog;
  int divisor;
  int ratio1;
  int ratio2;
public:
  int size;

  Beam(const vector<long>* c_prog): prog(*c_prog) {
    divisor = 1;
    ratio1 = 1;
    ratio2 = 2;
    size = 100 - 1;
  }
  bool inBeam(int x, int y) {
    deque<long> input;
    input.push_back(x);
    input.push_back(y);
    auto ic = new IntCode(&prog, input);
    auto res = ic->run_to_single_output();
    return res == 1;
  }
  auto part1() {
    int c = 0;
    int first = -1;
    int last = -1;
    for (int y = 0; y < 50; y++) {
      first = -1;
      last = -1;
      for (int x = 0; x < 50; x++) {
        if (this->inBeam(x, y)) {
          if (first == -1) {
            first = x;
          }
          last = x;
          c++;
        }
      }
    }
    this->ratio1 = first;
    this->ratio2 = last;
    this->divisor = 49;
    return c;
  }

  auto squareFits(int x, int y) {
    return this->inBeam(x, y) &&
      this->inBeam(x+this->size, y) &&
      this->inBeam(x, y+this->size);
  }

  auto squareFitsY(int y) {
    int min = (y * this->ratio1 / this->divisor);
    int max = (y * this->ratio2 / this->divisor);
    for (int x = min; x <= max; x++) {
      if (this->squareFits(x, y)) {
        return x;
      }
    }
    return 0;
  }

  auto part2() {
    int upper = 1;
    while (this->squareFitsY(upper) == 0) {
      upper *= 2;
    }
    int lower = upper / 2;
    while (true) {
      int mid = lower + (upper-lower) / 2;
      if (mid == lower) {
        break;
      }
      if (this->squareFitsY(mid) > 0) {
        upper = mid;
      } else {
        lower = mid;
      }
    }
    int x;
    int y;
    for (y = lower; y < lower + 5; y++) {
      x = this->squareFitsY(y);
      if (x > 0) {
        break;
      }
    }
    return x*10000 + y;
  }
};

int main() {
  vector<long> prog;
  long x;
  while ((cin >> x) && cin.ignore()) {
    prog.push_back(x);
  }
  auto beam = new Beam(&prog);
  cout << "Part 1: " << beam->part1() << "\n";
  cout << "Part 2: " << beam->part2() << "\n";
}
