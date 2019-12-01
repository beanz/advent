#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

int fuel(int m) {
  return m/3 - 2;
}

int fuelr(int m) {
  int s = 0;
  while (true) {
    int f = fuel(m);
    if (f <= 0) {
      break;
    }
    s += f;
    m = f;
  }
  return s;
}

int part1(const vector<int> &masses) {
  int s = 0;
  for (unsigned int i = 0; i < masses.size(); i++) {
    s += fuel(masses[i]);
  }
  return s;
}

int part2(const vector<int> &masses) {
  int s = 0;
  for (unsigned int i = 0; i < masses.size(); i++) {
    s += fuelr(masses[i]);
  }
  return s;
}

int main() {
  vector<int> masses;
  int m;
  cin >> m;
  while (cin) {
    masses.push_back(m);
    cin >> m;
  }
  AIEQ(part1(vector<int>{12}), 2);
  AIEQ(part1(vector<int>{14}), 2);
  AIEQ(part1(vector<int>{1969}), 654);
  AIEQ(part1(vector<int>{100756}), 33583);
  AIEQ(part1(vector<int>{12,14,1969,100756}), 34241);

  cout << "Part 1: " << part1(masses) << "\n";

  AIEQ(part2(vector<int>{12}), 2);
  AIEQ(part2(vector<int>{14}), 2);
  AIEQ(part2(vector<int>{1969}), 966);
  AIEQ(part2(vector<int>{100756}), 50346);
  AIEQ(part2(vector<int>{12,14,1969,100756}), 51316);

  cout << "Part 2: " << part2(masses) << "\n";
}

