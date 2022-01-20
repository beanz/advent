#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>

vector<char> calc(const vector<char> &s) {
  int REP[4] = {0, 1, 0, -1};
  vector <char> o;
  for (auto i = 1; i <= s.size(); i++) {
    int n = 0;
    for (auto j = 0; j < s.size(); j++) {
      int di = (1+j)/i;
      int m = REP[di%4];
      int d = s[j]*m;
      n += d;
    }
    n = (n < 0 ? -n : n) % 10;
    o.push_back(n);
  }
  return o;
}

string digits(const vector<char> &s, int num, int off) {
  string str = "";
  for (int i = 0; i < num ; i++) {
    str += s[i+off]+'0';
  }
  return str;
}

string part1(const vector<char> &inp, int phases) {
  vector <char> s = inp;
  for (int ph = 1; ph <= phases; ph++) {
    s = calc(s);
  }
  return digits(s, 8, 0);
}

int offset(const vector<char> &s, int num) {
  int r = 0;
  for (int i = 0; i < num ; i++) {
    r *= 10;
    r += s[i];
  }
  return r;
}

vector<char> calc2(const vector<char> &s) {
  vector <char> o;
  int sum = 0;
  for (auto i = 0; i < s.size(); i++) {
    sum += s[i];
  }
  for (auto i = 0; i < s.size(); i++) {
    int n = (sum < 0 ? -sum : sum) % 10;
    o.push_back(n);
    sum -= s[i];
  }
  return o;
}

string part2(const vector<char> &inp) {
  int off = offset(inp, 7);
  //printf("offset: %d\n", off);
  vector<char> inp10000;
  int o =0;
  for (int i = 0; i < 10000; i++) {
    for (int j = 0; j < inp.size(); j++) {
      if (o >= off) {
        inp10000.push_back(inp[j]);
      }
      o++;
    }
  }
  //printf("len=%zu offset=%i\n", inp.size()*10000, off);
  //printf("len=%zu\n", inp10000.size());
  for (int ph = 1; ph <= 100; ph++) {
    inp10000 = calc2(inp10000);
    //printf("Phase %d: %s\n", ph, digits(inp10000, 8, 0).c_str());
  }
  return digits(inp10000, 8, 0);
}

void tests() {
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  vector<char> chs;
  for (int i = 0; i < inp_len; i++) {
    chs.push_back(inp[i]-'0');
  }
  string p1 = part1(chs, 100);
  auto p2 = part2(chs);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
