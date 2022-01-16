import aoclib, intcode, point

type Hull = object
    tiles : Table[Point, bool]
    bb : BoundingBox
    pos : Point
    dir : Point

method input(this: var Hull): int64 {.base.} =
  if this.tiles.hasKey(this.pos) and this.tiles[this.pos]:
    return 1
  return 0

method output(this: var Hull, val: int64): void {.base.} =
  this.tiles[this.pos] = val == 1

method process(this: var Hull, col: int64, turn: int64): void {.base.} =
  this.output(col)
  if turn == 1:
    this.dir.cw
  else:
    this.dir.ccw
  this.pos.moveX(this.dir.x)
  this.pos.moveY(this.dir.y)
  this.bb.Add(this.pos)

proc run(prog: seq[int64], input: int64): Hull =
  var ic = NewIntCode(prog, input)
  var h = Hull(tiles: initTable[Point, bool](),
               bb: NewBoundingBox(),
               pos: Point(x: 0, y: 0),
               dir: Point(x: 0, y: -1))
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
  var s = ""
  for y in countup(h.bb.mini.y, h.bb.maxi.y):
    for x in countup(h.bb.mini.x, h.bb.maxi.x):
      let p = Point(x: x, y: y)
      if h.tiles.hasKey(p) and h.tiles[p]:
        s.add('#')
      else:
        s.add('.')
    s.add('\n')
  return s

const inputF = staticRead"input.txt"

benchme(inputF, proc (inp: string, bench: bool): void =
  var prog = inp.strip(chars = {'\n'}).split(",").map(parseBiggestInt).mapIt(it.int64)
  let p1 = part1(prog)
  let p2 = part2(prog)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2:\n", p2
)
