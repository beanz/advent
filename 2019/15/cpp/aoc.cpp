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

class IntCode {
  int ip;
  vector<long> prog;
  long base;
  bool done;
public:
  deque<long> inp, outp;
  IntCode(const vector<long>* c_prog, long input) : prog(*c_prog) {
    ip = 0;
    inp.push_back(input);
    done = false;
    base = 0;
  }

  IntCode* CloneWithInput(long input) {
    const vector<long> p = this->prog;
    auto ic = new IntCode(&p, input);
    ic->done = this->done;
    ic->base = this->base;
    ic->ip = this->ip;
    return ic;
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
  IntCode* try_direction() {
    while (!this->Done()) {
      this->run();
      if (this->outp.size() == 1) {
        return this;
      }
    }
    return NULL;
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

struct Point {
  int x, y;
  bool operator<(const Point& b) const {
    return x < b.x || (x == b.x && y < b.y);
  }
};

class BoundingBox {
  Point min, max;
public:
  BoundingBox() {
    max = Point{numeric_limits<int>::min(), numeric_limits<int>::min()};
    min = Point{numeric_limits<int>::max(), numeric_limits<int>::max()};
  }
  void Add(Point p) {
    if (p.x > max.x) {
      max.x = p.x;
    }
    if (p.x < min.x) {
      min.x = p.x;
    }
    if (p.y > max.y) {
      max.y = p.y;
    }
    if (p.y < min.y) {
      min.y = p.y;
    }
  }
  int MinX() {
    return min.x;
  };
  int MaxX() {
    return max.x;
  };
  int MinY() {
    return min.y;
  };
  int MaxY() {
    return max.y;
  };
};

typedef map<Point,bool> Visited;
typedef map<Point,bool> Wall;
typedef map<Point,bool> Safe;

class Ship {
  Wall *wall;
  BoundingBox *bb;
public:
  Point* os;
  IntCode* osic;
  int steps;
  Ship() {
    wall = new Wall();
    bb = new BoundingBox();
    os = NULL;
    osic = NULL;
    steps = 0;
  }
  auto AddWall(Point pos) {
    (*wall)[pos] = true;
  }
  auto BB() {
    return bb;
  }
  auto pp() {
    std::stringstream ss;
    for (auto y = bb->MinY(); y <= bb->MaxY(); y++) {
      for (auto x = bb->MinX(); x <= bb->MaxX(); x++) {
        if (x == 0 && y == 0) {
          ss << "S";
        } else if (os != NULL && os->x == x && os->y == y) {
          ss << "O";
        } else {
          auto p = Point{x,y};
          auto e = wall->find(p);
          if (e != wall->end()) {
            ss << "#";
          } else {
            ss << ".";
          }
        }
      }
      ss << "\n";
    }
    return ss.str();
  }
};

struct SearchRecord {
  Point pos;
  int steps;
  IntCode* ic;
};

int CompassToInput(string c) {
  if (c == "N") {
    return 1;
  } else if (c == "S") {
    return 2;
  } else if (c == "W") {
    return 3;
  } else {
    return 4;
  }
}

int CompassXOffset(string c) {
  if (c == "N") {
    return 0;
  } else if (c == "S") {
    return 0;
  } else if (c == "W") {
    return -1;
  } else {
    return 1;
  }
}

int CompassYOffset(string c) {
  if (c == "N") {
    return -1;
  } else if (c == "S") {
    return 1;
  } else if (c == "W") {
    return 0;
  } else {
    return 0;
  }
}

auto part1(const vector<long>* prog) {
  const vector<string> DIRECTIONS{"N", "S", "W", "E"};
  deque<SearchRecord> search;
  auto ship = new Ship();
  auto start = Point{0, 0};
  for (auto dir : DIRECTIONS) {
    auto np = Point{start.x + CompassXOffset(dir),
                    start.y + CompassYOffset(dir)};
    search.push_back(SearchRecord{np,
          1, new IntCode(prog, CompassToInput(dir))});
  }
  auto visited = new Visited();
  while (search.size() > 0) {
    auto cur = search.front();
    search.pop_front();
    auto ic = cur.ic->try_direction();
    auto res = ic->outp.front();
    ic->outp.pop_front();
    ship->BB()->Add(cur.pos);
    if (res == 0) { // wall
      ship->AddWall(cur.pos);
    } else if (res == 1) {
      for (auto dir : DIRECTIONS) {
        auto np = Point{cur.pos.x + CompassXOffset(dir),
                        cur.pos.y + CompassYOffset(dir)};
        if ((*visited)[np]) {
          continue;
        }
        (*visited)[np] = true;
        search.push_back(SearchRecord{np,
              cur.steps + 1,
              ic->CloneWithInput(CompassToInput(dir))});
      }
    } else if (res == 2) {
      ship->os = &(cur.pos);
      ship->osic = cur.ic;
      ship->steps = cur.steps;
    }
  }
  delete visited;
  return ship;
}

auto part2(Ship* ship) {
  const vector<string> DIRECTIONS{"N", "S", "W", "E"};
  deque<SearchRecord> search;
  auto start = *(ship->os);
  for (auto dir : DIRECTIONS) {
    auto np = Point{start.x + CompassXOffset(dir),
                    start.y + CompassYOffset(dir)};
    search.push_back(SearchRecord{np, 1,
          ship->osic->CloneWithInput(CompassToInput(dir))});
  }
  auto visited = new Visited();
  int max = numeric_limits<int>::min();
  while (search.size() > 0) {
    auto cur = search.front();
    search.pop_front();
    auto ic = cur.ic->try_direction();
    auto res = ic->outp.front();
    ic->outp.pop_front();
    ship->BB()->Add(cur.pos);
    if (res == 0) { // wall
      ship->AddWall(cur.pos);
    } else if (res == 1) {
      if (cur.steps > max) {
        max = cur.steps;
      }
      for (auto dir : DIRECTIONS) {
        auto np = Point{cur.pos.x + CompassXOffset(dir),
                        cur.pos.y + CompassYOffset(dir)};
        if ((*visited)[np]) {
          continue;
        }
        (*visited)[np] = true;
        search.push_back(SearchRecord{np,
              cur.steps + 1,
              ic->CloneWithInput(CompassToInput(dir))});
      }
    } else if (res == 2) {
      ship->os = &(cur.pos);
      ship->osic = cur.ic;
      ship->steps = cur.steps;
    }
  }
  delete visited;
  return max;
}

int main() {
  vector<long> prog;
  long x;
  while ((cin >> x) && cin.ignore()) {
    prog.push_back(x);
  }
  auto ship = part1(&prog);
  cout << "Part 1: " << ship->steps << "\n";
  cout << "Part 2: " << part2(ship) << "\n";
}
