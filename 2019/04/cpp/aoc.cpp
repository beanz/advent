#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include <cstring>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>

int count(const char* s, char ch) {
  int c = 0;
  for (int i = 0; i < strlen(s); i++) {
    if (s[i]==ch) {
      c++;
    }
  }
  return c;
}

int part1(const vector<unsigned int> &inp) {
  int c = 0;
  int8_t s[6] = {0,0,0,0,0};
  for (int i = inp[0]; i <= inp[1]; i++) {
    if (i < 100000 || i > 999999) {
      continue;
    }
    s[5] = (int8_t)(i % 10);
    s[4] = (int8_t)((i/10) % 10);
    if (s[4] > s[5]) { continue; }
    s[3] = (int8_t)((i/100) % 10);
    if (s[3] > s[4]) { continue; }
    s[2] = (int8_t)((i/1000) % 10);
    if (s[2] > s[3]) { continue; }
    s[1] = (int8_t)((i/10000) % 10);
    if (s[1] > s[2]) { continue; }
    s[0] = (int8_t)((i/100000) % 10);
    if (s[0] > s[1]) { continue; }
    if (s[0] == s[1] || s[1] == s[2] || s[2] == s[3] ||
        s[3] == s[4] || s[4] == s[5]) {
      c++;
    }
  }
  return c;
}

int part2(const vector<unsigned int> &inp) {
  int c = 0;
  int8_t s[6] = {};
  for (int i = inp[0]; i <= inp[1]; i++) {
    if (i < 100000 || i > 999999) {
      continue;
    }
    s[5] = (int8_t)(i % 10);
    s[4] = (int8_t)((i/10) % 10);
    if (s[4] > s[5]) { continue; }
    s[3] = (int8_t)((i/100) % 10);
    if (s[3] > s[4]) { continue; }
    s[2] = (int8_t)((i/1000) % 10);
    if (s[2] > s[3]) { continue; }
    s[1] = (int8_t)((i/10000) % 10);
    if (s[1] > s[2]) { continue; }
    s[0] = (int8_t)((i/100000) % 10);
    if (s[0] > s[1]) { continue; }
    if ((s[0] == s[1] && s[1] != s[2]) ||
      (s[1] == s[2] && s[2] != s[3] && s[1] != s[0]) ||
        (s[2] == s[3] && s[3] != s[4] && s[2] != s[1]) ||
        (s[3] == s[4] && s[4] != s[5] && s[3] != s[2]) ||
        (s[4] == s[5] && s[4] != s[3])) {
      c++;
    }
  }
  return c;
}

void tests() {
  AIEQ(part1(vector<unsigned int>{111111,111111}), 1);
  AIEQ(part1(vector<unsigned int>{223450,223450}), 0);
  AIEQ(part1(vector<unsigned int>{123789,123789}), 0);
  AIEQ(part1(vector<unsigned int>{123444,123444}), 1);
  AIEQ(part1(vector<unsigned int>{111122,111122}), 1);
  AIEQ(part2(vector<unsigned int>{112233,112233}), 1);
  AIEQ(part2(vector<unsigned int>{123444,123444}), 0);
  AIEQ(part2(vector<unsigned int>{111122,111122}), 1);
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto in = uints(inp_len, inp);
  auto p1 = part1(in);
  auto p2 = part2(in);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
