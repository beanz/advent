#include <stdio.h>
#include <iostream>
#include <vector>
#include <deque>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

#define ASEQ(act,exp) { if (act != exp) { throw std::runtime_error("assert: " + act + " should equal " + exp); } }

string pp_deque(const deque<long> v) {
  std::stringstream ss;
  for(size_t i = 0; i < v.size(); ++i) {
    if(i != 0)
      ss << ",";
    ss << v[i];
  }
  return ss.str();
}

string pp_vector(const vector<long> v) {
  std::stringstream ss;
  for(size_t i = 0; i < v.size(); ++i) {
    if(i != 0)
      ss << " ";
    ss << v[i];
  }
  return ss.str();
}

int op_arity(int op) {
  const vector<int> op_arity_map = {0,3,3,1,1,2,2,3,3,1};
  if (op == 99) {
    return 0;
  }
  return op_arity_map[op];
}

typedef struct {
  long op;
  vector<long> param;
  vector<long> addr;
} Inst;

struct Point {
  int x, y;
  bool operator<(const Point& b) const {
    return x < b.x || (x == b.x && y < b.y);
  }
};

class Direction {
  int x, y;
public:
  Direction(int px, int py) {
    x = px;
    y = py;
  }
  auto X() { return x; }
  auto Y() { return y; }
  auto CW() {
    if (x == 0 && y == -1) {
      return new Direction(1,0);
    } else if (x == 1 && y == 0) {
      return new Direction(0,1);
    } else if (x == 0 && y == 1) {
      return new Direction(-1,0);
    } else {
      return new Direction(0,-1);
    }
  }
  auto CCW() {
    if (x == 0 && y == -1) {
      return new Direction(-1,0);
    } else if (x == 1 && y == 0) {
      return new Direction(0,-1);
    } else if (x == 0 && y == 1) {
      return new Direction(1,0);
    } else {
      return new Direction(0,1);
    }
  }
};

typedef map<Point,bool> Tiles;

class Hull {
  Tiles* tiles;
  Point pos, min, max;
  Direction* dir;
public:
  Hull() : pos({0,0}), min({0,0}), max({0,0}) {
    tiles = new Tiles();
    dir = new Direction(0,-1);
  }
  auto size() {
    return tiles->size();
  }
  auto input() {
    auto e = tiles->find(pos);
    if (e != tiles->end() && e->second) {
      return 1;
    } else {
      return 0;
    }
  }
  auto output(bool val) {
    (*tiles)[pos] = val;
  }
  auto updateBoundingBox() {
    if (pos.x > max.x) {
      max.x = pos.x;
    }
    if (pos.x < min.x) {
      min.x = pos.x;
    }
    if (pos.y > max.y) {
      max.y = pos.y;
    }
    if (pos.y < min.y) {
      min.y = pos.y;
    }
  }
  auto process(int col, int turn) {
    output(col == 1 ? true : false);
    if (turn == 1) {
      dir = dir->CW();
    } else {
      dir = dir->CCW();
    }
    pos = Point{pos.x + dir->X(), pos.y + dir->Y()};
    updateBoundingBox();
  }
  auto pp() {
    std::stringstream ss;
    for (auto y = min.y; y <= max.y; y++) {
      for (auto x = min.x; x <= max.x; x++) {
        auto p = Point{x,y};
        auto e = tiles->find(p);
        if (e != tiles->end() && e->second) {
          ss << "#";
        } else {
          ss << ".";
        }
      }
      ss << "\n";
    }
    return ss.str();
  }
};

class IntCode {
  int ip;
  vector<long> prog;
  long base;
  bool done;
public:
  deque<long> inp, outp;
  IntCode(const vector<long>* c_prog, long phase) : prog(*c_prog) {
    ip = 0;
    inp.push_back(phase);
    done = false;
    base = 0;
  }

  bool Done() { return done; }

  auto run() {
    int l = (int)prog.size();
    while (ip < l) {
      auto inst = parse_inst();
      switch (inst->op) {
      case 1:
        prog[inst->addr[2]] = inst->param[0] + inst->param[1];
        break;
      case 2:
        prog[inst->addr[2]] = inst->param[0] * inst->param[1];
        break;
      case 3:
        if (inp.size() == 0) {
          prog[inst->addr[0]] = 0;
        } else {
          prog[inst->addr[0]] = inp.front();
          inp.pop_front();
        }
        break;
      case 4:
        outp.push_back(inst->param[0]);
        return 0;
      case 5:
        if (inst->param[0] != 0) {
          ip = inst->param[1];
        }
        break;
      case 6:
        if (inst->param[0] == 0) {
          ip = inst->param[1];
        }
        break;
      case 7:
        if (inst->param[0] < inst->param[1]) {
          prog[inst->addr[2]] = 1;
        } else {
          prog[inst->addr[2]] = 0;
        }
        break;
      case 8:
        if (inst->param[0] == inst->param[1]) {
          prog[inst->addr[2]] = 1;
        } else {
          prog[inst->addr[2]] = 0;
        }
        break;
      case 9:
        base += inst->param[0];
        break;
      case 99:
        delete inst;
        done = true;
        return 1;
      default:
        delete inst;
        done = true;
        return -1;
      }
      delete inst;
    }
    done = true;
    return -2;
  }

private:
  long safe_prog(long i) {
    if (prog.size() <= i) {
      while (prog.size() <= i) {
        prog.push_back(0);
      }
      return prog[i];
    }
    return prog[i];
  }
  Inst* parse_inst() {
    long raw_op = prog[ip++];
    long op = raw_op%100;
    int arity = op_arity(op);
    vector<long> mode = {
      (raw_op/100)%10, (raw_op/1000)%10, (raw_op/10000)%10
    };
    vector<long> param;
    vector<long> addr;
    for (int i = 0; i < arity; i++) {
      switch (mode[i]) {
      case 1:
        param.push_back(safe_prog(ip));
        addr.push_back(-99);
        break;
      case 2:
        param.push_back(safe_prog(base+safe_prog(ip)));
        {
          long a = base+safe_prog(ip);
          addr.push_back(a);
          safe_prog(a);
        }
        break;
      default: // 0
        param.push_back(safe_prog(safe_prog(ip)));
        {
          int a2 = safe_prog(ip);
          addr.push_back(a2);
          safe_prog(a2);
        }
      }
      ip++;
    }
    return new Inst{op, param, addr};
  };
};

auto run(const vector<long>* prog, long input) {
  auto h = new Hull();
  auto ic = new IntCode(prog, input);
  while (!ic->Done()) {
    ic->run();
    if (ic->outp.size() == 2) {
      auto col = ic->outp.front();
      ic->outp.pop_front();
      auto turn = ic->outp.front();
      ic->outp.pop_front();
      h->process(col, turn);
      ic->inp.push_back(h->input());
    }
  }
  return h;
}

int part1(const vector<long>* prog) {
  return run(prog, 0)->size();
}

string part2(const vector<long>* prog) {
  auto h = run(prog, 1);
  return h->pp();
}

int main() {
  vector<long> prog;
  long x;
  while ((cin >> x) && cin.ignore()) {
    prog.push_back(x);
  }
  cout << "Part 1: " << part1(&prog) << "\n";
  cout << "Part 2:\n" << part2(&prog) << "\n";
}
