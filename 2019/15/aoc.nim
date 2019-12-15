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

method cloneWithInput(this: IntComp, input: int64): IntComp {.base.} =
  var prog: seq[int64]
  deepCopy(prog, this.p)
  var ic = IntComp(ip: this.ip,
                   p: prog,
                   base: this.base, inp: initDeque[int64](),
                   outp: initDeque[int64](),
                   done: false)
  ic.inp.addLast(input)
  return ic

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

type BoundingBox = object
    mini: Point
    maxi: Point

proc NewBoundingBox() : BoundingBox =
  return BoundingBox(mini: Point(x: 2147483647, y: 2147483647),
                     maxi: Point(x: -2147483648, y: -2147483648))

method Add(this: var BoundingBox, p: Point): void {.base.} =
  if p.x < this.mini.x:
    this.mini.x = p.x
  if p.x > this.maxi.x:
    this.maxi.x = p.x
  if p.y < this.mini.y:
    this.mini.y = p.y
  if p.y > this.maxi.y:
    this.maxi.y = p.y

type Ship = object
    wall : Table[Point, bool]
    bb : BoundingBox
    os : ref Point
    osic : ref IntComp
    steps : int64

method String(this: var Ship): string {.base.} =
  var s = newString(42*42)
  for y in countup(this.bb.mini.y, this.bb.maxi.y):
    for x in countup(this.bb.mini.x, this.bb.maxi.x):
      if x == 0 and y == 0:
        s.add("S")
      elif this.os != nil and this.os.x == x and this.os.y == y:
        s.add("O")
      else:
        let p = Point(x: x, y: y)
        if this.wall.hasKey(p):
          s.add('#')
        else:
          s.add('.')
    s.add('\n')
  return s

proc compassToInput(dir : string) : int64 =
  case dir:
    of "N":
      return 1
    of "S":
      return 2
    of "W":
      return 3
    else:
      return 4

proc compassXOffset(dir : string) : int64 =
  case dir:
    of "N":
      return 0
    of "S":
      return 0
    of "W":
      return -1
    else:
      return 1

proc compassYOffset(dir : string) : int64 =
  case dir:
    of "N":
      return -1
    of "S":
      return 1
    of "W":
      return 0
    else:
      return 0

proc tryDirection(ic : var IntComp) : IntComp =
  while not ic.done:
    discard ic.run()
    if len(ic.outp) == 1:
      return ic

type Search = object
    pos: Point
    steps : int64
    ic: IntComp

proc part1(prog_c: seq[int64]): Ship =
  var search = initDeque[Search]()
  var ship = Ship(wall: initTable[Point,bool](),
                  bb: NewBoundingBox(),
                  os: nil,
                  osic: nil,
                  steps: 0)
  for dir in @["N", "S", "W", "E"]:
    var prog: seq[int64]
    deepCopy(prog, prog_c)
    var inp = initDeque[int64]()
    inp.addLast(compassToInput(dir))
    var nic = IntComp(ip: 0, p: prog, base: 0,
                      inp: inp, outp: initDeque[int64](), done: false)
    search.addLast(Search(pos: Point(x: compassXOffset(dir),
                                     y: compassYOffset(dir)),
                          steps: 1,
                          ic: nic))
  var visited = initTable[Point, bool]()
  while len(search) > 0:
    var cur = search.popFirst
    cur.ic = tryDirection(cur.ic)
    var res = cur.ic.outp.popFirst
    if res == 0:
      ship.wall[cur.pos] = true
    elif res == 1:
      for dir in @["N", "S", "W", "E"]:
        var np = Point(x: cur.pos.x + compassXOffset(dir),
                       y: cur.pos.y + compassYOffset(dir))
        if visited.hasKey(np):
          continue
        visited[np] = true
        var input = compassToInput(dir)
        var nic = cur.ic.cloneWithInput(input)
        search.addLast(Search(pos: np,
                          steps: cur.steps + 1,
                          ic: nic))
    elif res == 2:
      var p = new Point
      p.x = cur.pos.x
      p.y = cur.pos.y
      var ic = new IntComp
      deepcopy(ic.p, cur.ic.p)
      ic.ip = cur.ic.ip
      ic.base = cur.ic.base
      ship.os = p
      ship.osic = ic
      ship.steps = cur.steps
  return ship

proc part2(ship: var Ship): int64 =
  var search = initDeque[Search]()
  var ic = ship.osic
  for dir in @["N", "S", "W", "E"]:
    var prog: seq[int64]
    deepCopy(prog, ic.p)
    var inp = initDeque[int64]()
    inp.addLast(compassToInput(dir))
    var nic = IntComp(ip: ship.osic.ip, p: prog, base: ship.osic.base,
                      inp: inp, outp: initDeque[int64](), done: false)
    search.addLast(Search(pos: Point(x: ship.os.x + compassXOffset(dir),
                                     y: ship.os.y + compassYOffset(dir)),
                          steps: 1,
                          ic: nic))
  var visited = initTable[Point, bool]()
  var maxSteps = -2147483648
  while len(search) > 0:
    var cur = search.popFirst
    cur.ic = tryDirection(cur.ic)
    var res = cur.ic.outp.popFirst
    if res == 0:
      ship.wall[cur.pos] = true
    elif res == 1:
      if cur.steps > maxSteps:
         maxSteps = cur.steps
      for dir in @["N", "S", "W", "E"]:
        var np = Point(x: cur.pos.x + compassXOffset(dir),
                       y: cur.pos.y + compassYOffset(dir))
        if visited.hasKey(np):
          continue
        visited[np] = true
        if ship.wall.hasKey(np):
          continue
        var input = compassToInput(dir)
        var nic = cur.ic.cloneWithInput(input)
        search.addLast(Search(pos: np,
                          steps: cur.steps + 1,
                          ic: nic))
  return maxSteps

var ship = part1(prog)
echo "Part 1: ", ship.steps
echo "Part 2: ", part2(ship)
