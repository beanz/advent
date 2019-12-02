#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

int part1(const vector<int> &inp) {
  return 1;
}

int part2(const vector<int> &inp) {
  return 2;
}

int main() {
  vector<int> inp;
  int x;
  while ((cin >> x) && cin.ignore()) {
    inp.push_back(x);
  }
  AIEQ(part1(vector<int>{1,0,0,0,99}), 1);

  int res = part1(inp);
  cout << "Part 1: " << res << "\n";
  res = part2(inp);
  cout << "Part 2: " << res << "\n";
}
