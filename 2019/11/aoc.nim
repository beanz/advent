import strutils, sequtils, deques, tables, hashes, intcode

type Point = object
    x : int64
    y : int64

proc hash(p: Point): Hash =
  result = p.x.hash !& p.y.hash
  result = !$result
type Direction = object
    x : int64
    y : int64

method CW(this: var Direction): void {.base.} =
  if this.x == 0 and this.y == -1:
    this.x = 1
    this.y = 0
  elif this.x == 1 and this.y == 0:
    this.x = 0
    this.y = 1
  elif this.x == 0 and this.y == 1:
    this.x = -1
    this.y = 0
  else: # this.x == -1 and this.y == 0
    this.x = 0
    this.y = -1

method CCW(this: var Direction): void {.base.} =
  if this.x == 0 and this.y == -1:
    this.x = -1
    this.y = 0
  elif this.x == 1 and this.y == 0:
    this.x = 0
    this.y = -1
  elif this.x == 0 and this.y == 1:
    this.x = 1
    this.y = 0
  else: # this.x == -1 and this.y == 0
    this.x = 0
    this.y = 1

type Hull = object
    tiles : Table[Point, bool]
    pos : Point
    dir : Direction
    tmin : Point
    tmax : Point

method input(this: var Hull): int64 {.base.} =
  if this.tiles.hasKey(this.pos) and this.tiles[this.pos]:
    return 1
  return 0

method output(this: var Hull, val: int64): void {.base.} =
  this.tiles[this.pos] = val == 1

method updateBoundingBox(this: var Hull) {.base.} =
  if this.pos.x > this.tmax.x:
    this.tmax.x = this.pos.x
  if this.pos.x < this.tmin.x:
    this.tmin.x = this.pos.x
  if this.pos.y > this.tmax.y:
    this.tmax.y = this.pos.y
  if this.pos.y < this.tmin.y:
    this.tmin.y = this.pos.y

method process(this: var Hull, col: int64, turn: int64): void {.base.} =
  this.output(col)
  if turn == 1:
    this.dir.CW()
  else:
    this.dir.CCW()
  this.pos.x += this.dir.x
  this.pos.y += this.dir.y
  this.updateBoundingBox()

proc run(prog: seq[int64], input: int64): Hull =
  var ic = NewIntCode(prog, input)
  var h = Hull(tiles: initTable[Point, bool](),
               pos: Point(x: 0, y: 0),
               dir: Direction(x: 0, y: -1),
               tmin: Point(x: 0, y: 0),
               tmax: Point(x: 0, y: 0))
  while not ic.Done():
    let col = ic.NextOutput()
    if col == -99:
      break
    let turn = ic.NextOutput()
    h.process(col, turn)
    ic.AddInput(h.input())
  return h

proc part1(prog: seq[int64]): int64 =
  var h = run(prog, 0)
  return len(h.tiles)

proc part2(prog: seq[int64]): string =
  var h = run(prog, 2)
  var s = newString(80*8)
  for y in countup(h.tmin.y, h.tmax.y):
    for x in countup(h.tmin.x, h.tmax.x):
      let p = Point(x: x, y: y)
      if h.tiles.hasKey(p) and h.tiles[p]:
        s.add('#')
      else:
        s.add('.')
    s.add('\n')
  return s

var prog: seq[int64] = readLine(stdin).split(',').map(parseBiggestInt)
echo "Part 1: ", part1(prog)
echo "Part 2:\n", part2(prog)
