#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include <limits>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>

void tests() {
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto prog = longs(inp_len, inp);
  int w = 25;
  int h = 6;
  int l = w*h;
  int min = std::numeric_limits<int>::max();
  int res = 0;
  for (int i = 0; i < inp_len-1; i+=l) {
    int c[10] = {0,0,0};
    for (int j = 0; j < l; j++) {
      c[inp[i+j]-48]++;
    }
    if (c[0] < min) {
      res = c[1]*c[2];
      min = c[0];
    }
  }
  auto p1 = res;
  char p2[(w+1)*h];
  int i = 0;
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      for (int j = y*w+x; j < inp_len-1; j+=l) {
        if (inp[j] == '0') {
          p2[i] = ' ';
          i++;
          break;
        }
        if (inp[j] == '1') {
          p2[i] = '#';
          i++;
          break;
        }
      }
    }
    p2[i] = '\n';
    i++;
  }

  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2:\n" << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
