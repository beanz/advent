import hashes

type Point* = object
    x* : int64
    y* : int64

proc hash*(p: Point): Hash =
  result = p.x.hash !& p.y.hash
  result = !$result

method neighbours*(this: Point): seq[Point] {.base.} =
  return @[Point(x: this.x, y: this.y-1),
           Point(x: this.x-1, y: this.y),
           Point(x: this.x+1, y: this.y),
           Point(x: this.x, y: this.y+1)]

type BoundingBox* = object
    mini*: Point
    maxi*: Point

proc NewBoundingBox*() : BoundingBox =
  return BoundingBox(mini: Point(x: 2147483647, y: 2147483647),
                     maxi: Point(x: -2147483648, y: -2147483648))

method Add*(this: var BoundingBox, p: Point): void {.base.} =
  if p.x < this.mini.x:
    this.mini.x = p.x
  if p.x > this.maxi.x:
    this.maxi.x = p.x
  if p.y < this.mini.y:
    this.mini.y = p.y
  if p.y > this.maxi.y:
    this.maxi.y = p.y

type Direction* = object
    x* : int64
    y* : int64

method CW*(this: var Direction): Direction {.base.} =
  if this.x == 0 and this.y == -1:
    return Direction(x: 1, y: 0)
  elif this.x == 1 and this.y == 0:
    return Direction(x: 0, y: 1)
  elif this.x == 0 and this.y == 1:
    return Direction(x: -1, y: 0)
  else: # this.x == -1 and this.y == 0
    return Direction(x: 0, y: -1)

method CCW*(this: var Direction): Direction {.base.} =
  if this.x == 0 and this.y == -1:
    return Direction(x: -1, y: 0)
  elif this.x == 1 and this.y == 0:
    return Direction(x: 0, y: -1)
  elif this.x == 0 and this.y == 1:
    return Direction(x: 1, y: 0)
  else: # this.x == -1 and this.y == 0
    return Direction(x: 0, y: 1)

method In*(this: Point, dir: Direction): Point {.base.} =
  return Point(x: this.x + dir.x, y: this.y + dir.y)
