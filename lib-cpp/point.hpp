#ifndef POINT_HPP
#define POINT_HPP

#include <limits>
#include <sstream>
#include <vector>

using namespace std;

struct Point {
  int x, y;
  bool operator<(const Point& b) const {
    return x < b.x || (x == b.x && y < b.y);
  }
  bool operator==(const Point& b) const {
    return x == b.x && y == b.y;
  }
  vector<Point> neighbours() const {
    vector<Point> n;
    n.push_back(Point{x, y-1});
    n.push_back(Point{x-1, y});
    n.push_back(Point{x+1, y});
    n.push_back(Point{x, y+1});
    return n;
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
  auto Right() {
    return CW();
  }
  auto Left() {
    return CCW();
  }
  auto ToPointer() {
    if (x == 0 && y == -1) {
      return "^";
    } else if (x == 1 && y == 0) {
      return ">";
    } else if (x == 0 && y == 1) {
      return "v";
    } else {
      return "<";
    }
  }
};

#endif
