type Point = object
  x : int
  y : int

proc initPoint*(d : char) : Point {.raises: [ValueError]} =
  case d
  of 'N':
    return Point(x: 0, y: -1)
  of 'S':
    return Point(x: 0, y: 1)
  of 'E':
    return Point(x: 1, y: 0)
  of 'W':
    return Point(x: -1, y: 0)
  else:
    raise newException(ValueError, "invalid compass direction: " & d)

proc initPoint*(x : int, y: int) : Point =
  return Point(x: x, y: y)

method move*(p : var Point, o : Point, steps : int = 1) : void {.base.} =
  p.x += o.x * steps
  p.y += o.y * steps

method moveX*(p : var Point, x : int) : void {.base.} =
  p.x += x

method moveY*(p : var Point, y : int) : void {.base.} =
  p.y += y

method cw*(p : var Point) : void {.base.} =
  (p.x, p.y) = (-1 * p.y, p.x)

method ccw*(p : var Point) : void {.base.} =
  (p.x, p.y) = (p.y, -1 * p.x)

method manhattan*(p: var Point) : int {.base.} =
  return p.x.abs + p.y.abs

method neighbours*(p: var Point) : seq[Point] {.base.} =
  return @[Point(x: p.x, y: p.y-1), Point(x: p.x-1, y: p.y),
           Point(x: p.x+1, y: p.y), Point(x: p.x, y: p.y-1)]
