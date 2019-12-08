#include <stdio.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include <limits>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

int main(int argc, char *argv[]) {
  int w, h;
  if (argc < 3) {
    w = 25;
    h = 6;
  } else {
    w = atoi(argv[1]);
    h = atoi(argv[2]);
  }
  int l = w*h;
  string line;
  cin >> line;
  int min = std::numeric_limits<int>::max();
  int res = 0;
  for (int i = 0; i < line.size(); i+=l) {
    int c[10] = {0,0,0};
    for (int j = 0; j < l; j++) {
      c[line[i+j]-48]++;
    }
    if (c[0] < min) {
      res = c[1]*c[2];
      min = c[0];
    }
  }
  printf("Part 1: %d\n", res);

  printf("Part 2:\n");
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      for (int j = y*w+x; j < line.size(); j+=l) {
        if (line[j] == '0') {
          printf(" ");
          break;
        }
        if (line[j] == '1') {
          printf("#");
          break;
        }
      }
    }
    printf("\n");
  }
}
