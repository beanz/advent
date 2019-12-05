#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

int op_arity(int op) {
  vector<int> op_arity_map = {0,3,3,1,1,2,2,3,3};
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

typedef struct {
  int ip;
  vector<int> prog;
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
} Game;

auto run(const vector<int> prog_c, int in, vector<int> *out) {
  vector<int> prog = prog_c;
  auto g = new Game{0, prog};
  int l = (int)prog.size();
  while (g->ip < l) {
    auto inst = g->parse_inst();
    switch (inst->op) {
    case 1:
      g->prog[inst->addr[2]] = inst->param[0] + inst->param[1];
      break;
    case 2:
      g->prog[inst->addr[2]] = inst->param[0] * inst->param[1];
      break;
    case 3:
      g->prog[inst->addr[0]] = in;
      break;
    case 4:
      out->push_back(inst->param[0]);
      break;
    case 5:
      if (inst->param[0] != 0) {
        g->ip = inst->param[1];
      }
      break;
    case 6:
      if (inst->param[0] == 0) {
        g->ip = inst->param[1];
      }
      break;
    case 7:
      if (inst->param[0] < inst->param[1]) {
        g->prog[inst->addr[2]] = 1;
      } else {
        g->prog[inst->addr[2]] = 0;
      }
      break;
    case 8:
      if (inst->param[0] == inst->param[1]) {
        g->prog[inst->addr[2]] = 1;
      } else {
        g->prog[inst->addr[2]] = 0;
      }
      break;
    case 99:
      delete inst;
      return 0;
    default:
      delete inst;
      return -1;
    }
    delete inst;
  }
  return -2;
}

int part1(const vector<int> prog) {
  vector<int> out;
  auto g = run(prog, 1, &out);
  auto res = out[out.size()-1];
  return res;
}

int part2(const vector<int> prog, int input) {
  vector<int> out;
  auto g = run(prog, input, &out);
  auto res = out[0];
  return res;
}

int main() {
  vector<int> prog;
  int x;
  while ((cin >> x) && cin.ignore()) {
    prog.push_back(x);
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

  AIEQ(part2(vector<int>{3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8}, 8), 1);
  AIEQ(part2(vector<int>{3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8}, 4), 0);
  AIEQ(part2(vector<int>{3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8}, 7), 1);
  AIEQ(part2(vector<int>{3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8}, 8), 0);
  AIEQ(part2(vector<int>{3, 3, 1108, -1, 8, 3, 4, 3, 99}, 8), 1);
  AIEQ(part2(vector<int>{3, 3, 1108, -1, 8, 3, 4, 3, 99}, 9), 0);
  AIEQ(part2(vector<int>{3, 3, 1107, -1, 8, 3, 4, 3, 99}, 7), 1);
  AIEQ(part2(vector<int>{3, 3, 1107, -1, 8, 3, 4, 3, 99}, 9), 0);
  AIEQ(part2(vector<int>{3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99,
          -1, 0, 1, 9}, 2), 1);
  AIEQ(part2(vector<int>{3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99,
          -1, 0, 1, 9}, 0), 0);
  AIEQ(part2(vector<int>{3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1}, 3),
       1);
  AIEQ(part2(vector<int>{3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1}, 0),
       0);
  AIEQ(part2(vector<int>{3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
          20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20,
          1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
          1, 46, 98, 99}, 5), 999);
  AIEQ(part2(vector<int>{3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
          20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20,
          1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
          1, 46, 98, 99}, 8), 1000);
  AIEQ(part2(vector<int>{3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
          20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20,
          1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
          1, 46, 98, 99}, 9), 1001);

  cout << "Part 1: " << part1(prog) << "\n";
  cout << "Part 2: " << part2(prog, 5) << "\n";
}
