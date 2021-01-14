#ifndef INTCODE_HPP
#define INTCODE_HPP

#include <string>
#include <deque>
#include <vector>
#include <functional>

using namespace std;

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

  IntCode(const vector<long>* c_prog)
    : prog(*c_prog)
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
    inp.push_back(input);
  }

  IntCode(const vector<long>* c_prog, string input)
    : prog(*c_prog)
  {
    ip = 0;
    done = false;
    base = 0;
    for (auto i = 0; i < input.size(); i++) {
      inp.push_back((long)input[i]);
    }
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
      // printf("ip=%d\n", ip);
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
          // printf("in < eof\n");
          ip -= (op_arity(inst->op)+1); // backup to run again
          delete inst;
          return 2;
        } else {
          // printf("in < %ld\n", inp.front());
          prog[inst->addr[0]] = inp.front();
          inp.pop_front();
        }
        break;
      case 4:
        // printf("out < %ld\n", inst->param[0]);
        outp.push_back(inst->param[0]);
        delete inst;
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
      if (this->outp.size() >= 1) {
        auto res = this->outp.front();
        this->outp.pop_front();
        return res;
      }
    }
    return -1;
  }

  vector<long> output(int n) {
    vector<long> res;
    if (this->outp.size() >= n) {
      for (int i = 0; i < n; i++) {
        res.push_back(this->outp.front());
        this->outp.pop_front();
      }
    }
    return res;
  }

  string outputString() {
    string res = "";
    while (this->outp.size() > 0) {
      res += char(this->outp.front());
      this->outp.pop_front();
    }
    return res;
  }

  void addInput(string s) {
    for (auto i = 0; i < s.size(); i++) {
      inp.push_back((long)s[i]);
    }
  }

  bool run_with_callbacks(std::function<long()> inf, std::function<void(vector<long>)> outf, int outn) {
    while (!this->Done()) {
      auto rc = this->run();
      if (rc == 0) {
        if (this->outp.size() >= outn) {
          vector<long> o;
          for (int i = 0; i < outn; i++) {
            o.push_back(this->outp.front());
            this->outp.pop_front();
          }
          outf(o);
        }
        continue;
      }
      if (rc == 1) {
        return true;
      }
      if (rc == 2) {
        this->inp.push_back(inf());
        continue;
      }
      printf("IntCode error\n");
    }
    return false;
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

#endif
