#include <stdio.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <assert.h>
#include <map>
#include <cmath>

using namespace std;

#define AIEQ(act,exp) { long a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

typedef string Chemical;

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

auto quantity_chemical(string s) {
  auto p = s.find(" ");
  return make_pair(s.substr(p+1), stol(s.substr(0,p)));
}

class Factory {
  Reactions* reactions;
  Surplus* surplus;
  Total* total;
public:
  Factory(const vector<string> &lines) {
    reactions = new Reactions();
    surplus = new Surplus();
    total = new Total();
    for (auto line : lines) {
      auto p = line.find(" => ");
      auto inStr = line.substr(0,p);
      auto outpair = quantity_chemical(line.substr(p+4));
      string ch = outpair.first;
      long num = outpair.second;
      size_t cur, prev = 0;
      vector<Input> inputs;
      cur = inStr.find(", ");
      while (cur != string::npos) {
        auto inpair = quantity_chemical(inStr.substr(prev, cur-prev));
        inputs.push_back(Input{inpair.first, inpair.second});
        prev = cur + 2;
        cur = inStr.find(", ", prev);
      }
      auto inpair = quantity_chemical(inStr.substr(prev, cur-prev));
      inputs.push_back(Input{inpair.first, inpair.second});
      reactions->insert(make_pair(ch, Reaction{num, inputs}));
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
  void requirements(Chemical ch, long needed) {
    if (ch == "ORE") {
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
    requirements("FUEL", num);
    return (*this->total)["ORE"];
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

vector<string> readlines(string file) {
  ifstream inf(file);
  vector<string> lines;
  string l;
  while (getline(inf, l)) {
    lines.push_back(l);
  }
  return lines;
}

int main() {
  vector<string> lines;
  string l;
  while (getline(cin, l)) {
    lines.push_back(l);
  }
  AIEQ((new Factory(readlines("test1a.txt")))->part1(), 31);
  AIEQ((new Factory(readlines("test1b.txt")))->part1(), 165);
  AIEQ((new Factory(readlines("test1c.txt")))->part1(), 13312);
  AIEQ((new Factory(readlines("test1d.txt")))->part1(), 180697);
  AIEQ((new Factory(readlines("test1e.txt")))->part1(), 2210736);
  AIEQ((new Factory(readlines("test1a.txt")))->part2(), 34482758620);
  AIEQ((new Factory(readlines("test1b.txt")))->part2(), 6323777403);
  AIEQ((new Factory(readlines("test1c.txt")))->part2(), 82892753);
  AIEQ((new Factory(readlines("test1d.txt")))->part2(), 5586022);
  AIEQ((new Factory(readlines("test1e.txt")))->part2(), 460664);

  auto f = new Factory(lines);
  cout << "Part 1: " << f->part1() << "\n";
  cout << "Part 2: " << f->part2() << "\n";
}
