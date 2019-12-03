#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <assert.h>
#include <map>
#include <string>
#include <limits>

using namespace std;

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }

typedef pair<int, int> point;
typedef map<point,int> path;
typedef pair<char,int> wire_move;

auto make_move(string m) {
  char d = m[0];
  int c = std::stoi(m.substr(1));
  return std::make_pair(d, c);
}

auto find_path(string line) {
  auto p = new path;
  auto start = 0U;
  auto end = line.find(',');

  vector<wire_move> wire;
  while (end != std::string::npos) {
    auto m = make_move(line.substr(start, end - start));
    wire.push_back(m);
    start = end + 1;
    end = line.find(',', start);
  }
  auto m = make_move(line.substr(start, end - start));
  wire.push_back(m);

  int x = 0;
  int y = 0;
  int steps = 0;
  for (int i = 0; i < wire.size(); i++) {
    auto m = wire[i];
    for (int j = 0; j < m.second; j++) {
      switch (m.first) {
        case 'U':
          y--;
          break;
        case 'D':
          y++;
          break;
        case 'L':
          x--;
          break;
        case 'R':
          x++;
          break;
        }
      steps++;
      p->insert(std::make_pair(std::make_pair(x, y), steps));
    }
  }
  return p;
}

auto calc(const vector<string> &lines) {
  auto p1 = find_path(lines[0]);
  auto p2 = find_path(lines[1]);
  int steps = std::numeric_limits<int>::max();
  int dist = std::numeric_limits<int>::max();
  for (auto p : *p1) {
    auto itr = p2->find(std::make_pair(p.first.first, p.first.second));
    if (itr != p2->end()) {
      int s = p.second + itr->second;
      if (s < steps) {
        steps = s;
      }
      int d = abs(p.first.first) + abs(p.first.second);
      if (d < dist) {
        dist = d;
      }
    }
  }
  return std::make_pair(dist, steps);
}

int main() {
  vector<string> lines;
  string l;
  cin >> l;
  while (cin) {
    lines.push_back(l);
    cin >> l;
  }
  AIEQ(calc(vector<string>{"R8,U5,L5,D3", "U7,R6,D4,L4"}).first, 6);
  AIEQ(calc(vector<string>{"R8,U5,L5,D3", "U7,R6,D4,L4"}).second, 30);
  AIEQ(calc(vector<string>{"R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
          "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"}).first, 135 );
  AIEQ(calc(vector<string>{"R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
          "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"}).second, 410 );
  AIEQ(calc(vector<string>{"R75,D30,R83,U83,L12,D49,R71,U7,L72",
          "U62,R66,U55,R34,D71,R55,D58,R83"}).first, 159);
  AIEQ(calc(vector<string>{"R75,D30,R83,U83,L12,D49,R71,U7,L72",
          "U62,R66,U55,R34,D71,R55,D58,R83"}).second, 610);

  auto res = calc(lines);
  cout << "Part 1: " << res.first << "\n";
  cout << "Part 2: " << res.second << "\n";
}
