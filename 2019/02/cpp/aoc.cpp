#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

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

int main() {
  vector<int> prog;
  int x;
  while ((cin >> x) && cin.ignore()) {
    prog.push_back(x);
  }
  AIEQ(part1(vector<int>{1,0,0,0,99}), 2);
  AIEQ(part1(vector<int>{1,0,0,0,99}), 2);
  AIEQ(part1(vector<int>{1,1,1,4,99,5,6,0,99}), 30);

  prog[1] = 12;
  prog[2] = 2;
  int res = part1(prog);
  cout << "Part 1: " << res << "\n";
  res = part2(prog);
  cout << "Part 2: " << res << "\n";
}
