#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include <cstring>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

int count(const char* s, char ch) {
  int c = 0;
  for (int i = 0; i < strlen(s); i++) {
    if (s[i]==ch) {
      c++;
    }
  }
  return c;
}

int part1(const vector<int> &inp) {
  int c = 0;
  for (int i = inp[0]; i <= inp[1]; i++) {
    const char* s = to_string(i).c_str();
    if (strlen(s) != 6) { continue; }
    if (s[0] > s[1] || s[1] > s[2] || s[2] > s[3] ||
        s[3] > s[4] || s[4] > s[5]) { continue; }
    for (char ch = 48; ch <= 57; ch++) {
      if (count(s, ch) >= 2) {
        c++;
        break;
      }
    }
  }
  return c;
}

int part2(const vector<int> &inp) {
  int c = 0;
  for (int i = inp[0]; i <= inp[1]; i++) {
    const char* s = to_string(i).c_str();
    if (strlen(s) != 6) { continue; }
    if (s[0] > s[1] || s[1] > s[2] || s[2] > s[3] ||
        s[3] > s[4] || s[4] > s[5]) { continue; }
    for (char ch = 48; ch <= 57; ch++) {
      if (count(s, ch) == 2) {
        c++;
        break;
      }
    }
  }
  return c;
}

int main() {
  vector<int> inp;
  int x;
  while ((cin >> x) && cin.ignore()) {
    inp.push_back(x);
  }
  AIEQ(part1(vector<int>{111111,111111}), 1);
  AIEQ(part1(vector<int>{223450,223450}), 0);
  AIEQ(part1(vector<int>{123789,123789}), 0);
  AIEQ(part1(vector<int>{123444,123444}), 1);
  AIEQ(part1(vector<int>{111122,111122}), 1);

  cout << "Part 1: " << part1(inp) << "\n";

  AIEQ(part2(vector<int>{112233,112233}), 1);
  AIEQ(part2(vector<int>{123444,123444}), 0);
  AIEQ(part2(vector<int>{111122,111122}), 1);

  cout << "Part 2: " << part2(inp) << "\n";
}
