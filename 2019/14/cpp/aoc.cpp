#include <stdio.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <assert.h>
#include <map>
#include <cmath>

using namespace std;

#include "input.h"
#include <input.hpp>
#include <assert.hpp>

typedef unsigned int Chemical;

Chemical scanChemical(unsigned char *s, size_t* i, size_t len) {
  Chemical n = 0;
  for (;*i < len; (*i)++) {
    if ('A' <= s[*i] && s[*i] <= 'Z') {
      n = 27*n + (Chemical)(s[*i]-'@');
    } else {
      break;
    }
  }
  return n;
}

struct Input {
  Chemical ch;
  long num;
};

struct Reaction {
  long num;
  vector<Input> inputs;
};

typedef map<Chemical, long> Surplus;
typedef map<Chemical, long> Total;
typedef map<Chemical, Reaction> Reactions;

auto scanQuantityChemical(unsigned char *s, size_t* i, size_t len) {
  long n = (long)scanUint(s, i, len);
  (*i)++;
  return Input{scanChemical(s, i, len), n};
}

class Factory {
  Reactions* reactions;
  Surplus* surplus;
  Total* total;
public:
  Factory(unsigned char *inp, size_t len) {
    reactions = new Reactions();
    surplus = new Surplus();
    total = new Total();
    size_t i = 0;
    while (i < len) {
      vector<Input> inputs;
      while ('0' <= inp[i] && inp[i] <= '9') {
        auto qc = scanQuantityChemical(inp, &i, len);
        inputs.push_back(qc);
        if (inp[i] == ' ') {
          break;
        }
        i += 2;
      }
      if (inp[i+1] != '=') {
        printf("unexpected input at ' =>' got '%c%c'\n", inp[i], inp[i+1]);
        exit(1);
      }
      i += 4;
      auto out = scanQuantityChemical(inp, &i, len);
      if (inp[i] != '\n') {
        printf("unexpected input at EOL got '%c'\n", inp[i]);
        exit(1);
      }
      i++;
      reactions->insert(make_pair(out.ch, Reaction{out.num, inputs}));
    }
  }
  void reset() {
    delete this->surplus;
    this->surplus = new Surplus();
    delete this->total;
    this->total = new Total();
  }
  long get_surplus(Chemical ch) {
    return (*this->surplus)[ch];
  }
  long use_surplus(Chemical ch, long num) {
    (*this->surplus)[ch] -= num;
    return (*this->surplus)[ch];
  }
  long produce(Chemical ch, long num) {
    (*this->total)[ch] += num;
    return (*this->total)[ch];
  }

  const long ORE = (('O'-'@')*27 + ('R'-'@'))*27+('E'-'@');
  const long FUEL = ((('F'-'@')*27 + ('U'-'@'))*27+('E'-'@'))*27 + ('L'-'@');
  void requirements(Chemical ch, long needed) {
    if (ch == ORE) {
      return;
    }
    auto r = (*this->reactions)[ch];
    long avail = this->get_surplus(ch);
    if (avail > needed) {
      this->use_surplus(ch, needed);
      return;
    }
    if (avail > 0) {
      needed -= avail;
      this->use_surplus(ch, avail);
    }
    long required = (long)ceil((double)needed / (double)r.num);
    auto surplus = r.num * required - needed;
    this->use_surplus(ch, -surplus);
    for (auto in : r.inputs) {
      this->produce(in.ch, in.num * required);
      this->requirements(in.ch, in.num * required);
    }
  }
  long ore_for(long num) {
    requirements(FUEL, num);
    return (*this->total)[ORE];
  }
  long part1() {
    return this->ore_for(1);
  }
  long part2() {
    long target = 1000000000000;
    long upper = 1;
    while (this->ore_for(upper) < target) {
      this->reset();
      upper *= 2;
    }
    long lower = upper / 2;
    while (true) {
      long mid = lower + (upper-lower)/2;
      if (mid == lower) {
        break;
      }
      this->reset();
      if (ore_for(mid) > target) {
        upper = mid;
      } else {
        lower = mid;
      }
    }
    return lower;
  }
};

void tests() {
  auto test1a = getfile("test1a.txt");
  auto test1b = getfile("test1b.txt");
  auto test1c = getfile("test1c.txt");
  auto test1d = getfile("test1d.txt");
  auto test1e = getfile("test1e.txt");
  ALEQ((new Factory(test1a.first, test1a.second))->part1(), 31);
  ALEQ((new Factory(test1b.first, test1b.second))->part1(), 165);
  ALEQ((new Factory(test1c.first, test1c.second))->part1(), 13312);
  ALEQ((new Factory(test1d.first, test1d.second))->part1(), 180697);
  ALEQ((new Factory(test1e.first, test1e.second))->part1(), 2210736);
  ALEQ((new Factory(test1a.first, test1a.second))->part2(), 34482758620);
  ALEQ((new Factory(test1b.first, test1b.second))->part2(), 6323777403);
  ALEQ((new Factory(test1c.first, test1c.second))->part2(), 82892753);
  ALEQ((new Factory(test1d.first, test1d.second))->part2(), 5586022);
  ALEQ((new Factory(test1e.first, test1e.second))->part2(), 460664);
}

void run(unsigned int inp_len, unsigned char* inp, bool is_bench) {
  auto f = new Factory(inp, inp_len);
  auto p1 = f->part1();
  auto p2 = f->part2();
  if (!is_bench) {
    cout << "Part 1: " << p1 << "\n";
    cout << "Part 2: " << p2 << "\n";
  }
}

int main(int argc, char **argv) {
  if (is_test()) { tests(); }
  benchme(argc, argv, input_txt_len, input_txt, run);
}
