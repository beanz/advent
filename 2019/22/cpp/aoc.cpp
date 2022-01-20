#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>
#include <boost/foreach.hpp>
#include <boost/multiprecision/cpp_int.hpp>

using namespace std;
using namespace boost::multiprecision;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>

// https://rosettacode.org/wiki/Modular_inverse#C.2B.2B
int256_t modinv(int256_t a, int256_t b) {
  int256_t b0 = b, t, q;
  int256_t x0 = 0, x1 = 1;
  if (b == 1) return 1;
  while (a > 1) {
    q = a / b;
    t = b, b = a % b, a = t;
    t = x0, x0 = x1 - q * x0, x1 = t;
  }
  if (x1 < 0) x1 += b0;
  return x1;
}

enum ShuffleKind { Deal = 0, Cut = 1, DealInc = 2 };

struct Params {
  int256_t a;
  int256_t b;
};

class Shuffle {
public:
  ShuffleKind kind;
  int256_t num;
  Shuffle(string s) {
    if (s.rfind("deal into", 0) == 0) {
      kind = Deal;
      num = 0;
      return;
    }
    num = stoi(s.substr(s.rfind(" ")+1));
    if (s.rfind("cut", 0) == 0) {
      kind = Cut;
    } else {
      kind = DealInc;
    }
  }
  Params params(int256_t a, int256_t b, int256_t num_cards) {
    int256_t na = 0;
    int256_t nb = 0;
    switch (this->kind) {
    case Deal:
      na = -a;
      nb = -b-1;
      break;
    case Cut:
      na = a;
      nb = b - this->num;
      break;
    default:
      na = a * this->num;
      nb = b * this->num;
    }
    return Params{(na+num_cards) % num_cards, (nb+num_cards) % num_cards};
  }
  Params reverse_params(int256_t a, int256_t b, int256_t num_cards) {
    int256_t na = 0;
    int256_t nb = 0;
    switch (this->kind) {
    case Deal:
      na = -a;
      nb = -b-1;
      break;
    case Cut:
      na = a;
      nb = b + this->num;
      break;
    default:
      int256_t m = modinv(this->num, num_cards);
      na = a * m;
      nb = b * m;
    }
    return Params{(na+num_cards) % num_cards, (nb+num_cards) % num_cards};
  }
};

int256_t modpow(int256_t b, int256_t e, int256_t m) {
  int256_t res = 1;
  while (e > 0) {
    if ((e%2) == 1) {
      res = (res * b) % m;
    }
    e = e / 2;
    b = (b * b) % m;
  }
  return res;
}

class Game {
  vector<Shuffle> shuffles;
  int256_t cards;
public:
  Game(vector<string> &inp, int256_t num_cards) {
    for (auto l : inp) {
      shuffles.push_back(Shuffle(l));
    }
    cards = num_cards;
  }
  Params params() {
    int256_t a = 1;
    int256_t b = 0;
    for (auto s : this->shuffles) {
      Params p = s.params(a, b, this->cards);
      a = p.a;
      b = p.b;
    }
    return Params{a, b};
  }
  int256_t forward(int256_t card) {
    Params p = this->params();
    return (((p.a * card) + p.b) % this->cards);
  }
  Params reverse_params() {
    int256_t a = 1;
    int256_t b = 0;
    BOOST_REVERSE_FOREACH(auto s, this->shuffles) {
      Params p = s.reverse_params(a, b, this->cards);
      a = p.a;
      b = p.b;
    }
    return Params{a, b};
  }
  int256_t backward(int256_t card, int256_t rounds) {
    Params p = this->reverse_params();
    int256_t exp = modpow(p.a, rounds, this->cards);
    int256_t im = modinv(p.a-1, this->cards);
    return ((((exp-1) * im) * p.b) + (exp * card)) % this->cards;
  }
};

void tests() {
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  vector<string> ln = lines(inp_len, inp);
  Game* game = new Game(ln, 10007);
  auto p1 = game->forward(2019);
  game = new Game(ln, 119315717514047);
  int256_t rounds = 101741582076661;
  auto p2 = game->backward(2020, rounds);
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
