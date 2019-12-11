import strutils, sequtils, deques, tables, hashes

var prog: seq[int64] = readLine(stdin).split(',').map(parseBiggestInt)

type Inst = object
    op: int64
    param: array[3, int64]
    address: array[3, int64]

type IntComp = object
    ip: int64
    base: int64
    p: seq[int64]
    inp: Deque[int64]
    outp: Deque[int64]
    done: bool

proc opArity(op: int64): int64 =
  if op == 99:
    return 0
  return [0,3,3,1,1,2,2,3,3,1][op]

method sprog(this: var IntComp, i: int64): int64 {.base.} =
  while len(this.p) <= i:
    this.p.add(0)
  return this.p[i]

method parseInst(this: var IntComp): Inst {.base.} =
  var rawOp = this.p[this.ip]
  this.ip += 1
  var inst = Inst(op: (rawOp mod 100))
  let mode: array[3,int64] = [
      (rawOp div 100) mod 10,
      (rawOp div 1000) mod 10,
      (rawOp div 10000) mod 10]
  for i in countup(int64(0), opArity(inst.op)-1):
    case mode[i]:
    of 1:
      inst.param[i] = this.sprog(this.ip)
      inst.address[i] = -99
    of 2:
      inst.param[i] = this.sprog(this.base+this.p[this.ip])
      inst.address[i] = this.base+this.p[this.ip]
    else:
      inst.param[i] = this.sprog(this.p[this.ip])
      inst.address[i] = this.p[this.ip]
    this.ip += 1
  return inst

method run(this: var IntComp): int64 {.base.} =
  var l : int64 = len(this.p)
  while this.ip < l:
    let inst = this.parseInst()
    case inst.op
    of 1:
      this.p[inst.address[2]] = inst.param[0] + inst.param[1]
    of 2:
      this.p[inst.address[2]] = inst.param[0] * inst.param[1]
    of 3:
      if len(this.inp) == 0:
        this.p[inst.address[0]] = 0
      else:
        this.p[inst.address[0]] = this.inp.popFirst
      #echo "3: ", this.p[inst.address[0]], " => ", inst.address[0]
    of 4:
      #echo "4: ", inst.param[0], " => output"
      this.outp.addLast(inst.param[0])
      return 0
    of 5:
      if inst.param[0] != 0:
        this.ip = inst.param[1]
    of 6:
      if inst.param[0] == 0:
        this.ip = inst.param[1]
    of 7:
      if inst.param[0] < inst.param[1]:
        this.p[inst.address[2]] = 1
      else:
        this.p[inst.address[2]] = 0
    of 8:
      if inst.param[0] == inst.param[1]:
        this.p[inst.address[2]] = 1
      else:
        this.p[inst.address[2]] = 0
    of 9:
      this.base += inst.param[0]
    of 99:
      this.done = true
      return 1
    else:
      this.done = true
      return -1
  this.done = true
  return -2

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

proc run(prog_c: seq[int64], input: int64): Hull =
  var prog: seq[int64]
  deepCopy(prog, prog_c)
  var inp = initDeque[int64]()
  inp.addLast(input)
  var outp = initDeque[int64]()
  var ic = IntComp(ip: 0, p: prog, base: 0, inp: inp, outp: outp,
                   done: false)
  var h = Hull(tiles: initTable[Point, bool](),
               pos: Point(x: 0, y: 0),
               dir: Direction(x: 0, y: -1),
               tmin: Point(x: 0, y: 0),
               tmax: Point(x: 0, y: 0))
  while not ic.done:
    let rc = ic.run()
    if len(ic.outp) == 2:
      h.process(ic.outp.popFirst, ic.outp.popFirst)
      ic.inp.addLast(h.input())
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


echo "Part 1: ", part1(prog)
echo "Part 2:\n", part2(prog)
