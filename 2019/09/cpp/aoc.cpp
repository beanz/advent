#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
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
  IntCode(const vector<long>* c_prog, long phase) : prog(*c_prog) {
    ip = 0;
    inp.push_back(phase);
    done = false;
    base = 0;
  }

  bool Done() { return done; }

  auto run() {
    int l = (int)prog.size();
    while (ip < l) {
      //printf("ip=%d: [%d %d %d %d] b=%d\n", ip,
      //       prog[ip], prog[ip+1], prog[ip+2], prog[ip+3], base);
      //printf("M: %d [%s]\n", ip, pp_vector(prog).c_str());
      auto inst = parse_inst();
      //printf("op=%ld param=[%s] addr=[%s]\n", inst->op,
      //       pp_vector(inst->param).c_str(), pp_vector(inst->addr).c_str());
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
        //printf("  base += %d == %d\n", inst->param[0], base);
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
      //printf("Extending to size %ld\n", i);
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

string run(const vector<long>* prog, long input) {
  auto ic = new IntCode(prog, input);
  while (!ic->Done()) {
    long rc = ic->run();
  }
  return pp_deque(ic->outp);
}

string part1(const vector<long>* prog) {
  return run(prog, 1);
}

string part2(const vector<long>* prog) {
  return run(prog, 2);
}

int main() {
  vector<long> prog;
  long x;
  while ((cin >> x) && cin.ignore()) {
    prog.push_back(x);
  }

  auto tp = vector<long>{109,1,204,-1,1001,100,1,100,1008,100,16,101,
                        1006,101,0,99};
  ASEQ(run(&tp,1),
       "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99");

  tp = vector<long>{1102,34915192,34915192,7,4,7,99,0};
  ASEQ(run(&tp,1), "1219070632396864");

  tp = vector<long>{104,1125899906842624,99};
  ASEQ(run(&tp,1), "1125899906842624");

  cout << "Part 1: " << part1(&prog) << "\n";
  cout << "Part 2: " << part2(&prog) << "\n";
}
