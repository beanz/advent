import strutils, sequtils, deques, os

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

method nextOutput(this: var IntComp): int64 {.base.} =
  while not this.done:
    discard this.run()
    if len(this.outp) == 1:
      return this.outp.popFirst
  return -99

type Beam = object
    prog: seq[int64]
    size: int64
    ratio1: int64
    ratio2: int64
    divisor: int64

proc NewBeam(c_prog : seq[int64]) : Beam =
  var prog: seq[int64]
  deepCopy(prog, c_prog)
  return Beam(prog: prog, size: 100, ratio1: 0, ratio2: 0, divisor: 0)

method inBeam(this: var Beam, x : int64, y: int64): bool {.base.} =
    var prog: seq[int64]
    deepCopy(prog, this.prog)
    var inp = initDeque[int64]()
    inp.addLast(x)
    inp.addLast(y)
    var ic = IntComp(ip: 0, p: prog, base: 0,
                      inp: inp, outp: initDeque[int64](), done: false)
    return ic.nextOutput == 1

method part1(this: var Beam): int64 {.base.} =
  var count : int64 = 0
  var first : int64 = -1
  var last : int64 = -1
  for y in countup(int64(0), 49):
    first = -1
    last = -1
    for x in countup(int64(0), 49):
      if this.inBeam(x, y):
        if first == -1:
          first = x
        last = x
        count += 1
  this.ratio1 = first
  this.ratio2 = last
  this.divisor = 49
  return count

method squareFits(this: var Beam, x : int64, y : int64) : bool {.base.} =
  return(this.inBeam(x,y) and
         this.inBeam(x+this.size-1,y) and
         this.inBeam(x, y+this.size-1))

method squareFitsY(this: var Beam, y : int64) : int64 {.base.} =
  var xmin = (y * this.ratio1 div this.divisor)
  var xmax = (y * this.ratio2 div this.divisor)
  for x in countup(xmin, xmax):
    if this.squareFits(x, y):
      return x
  return 0

method part2(this: var Beam): int64 {.base.} =
  var upper : int64 = 1
  while this.squareFitsY(upper) == 0:
    upper *= 2
  var lower = upper div 2
  while true:
    var mid = (lower + upper) div 2
    if mid == lower:
      break
    if this.squareFitsY(mid) > 0:
      upper = mid
    else:
      lower = mid
  for y in countup(lower, lower + 5):
    var x = this.squareFitsY(y)
    if x > 0:
      return x*10000 + y
  return -1

proc readFile(file : string) : seq[int64] =
  let f = open(file)
  return f.readLine().split(',').map(parseBiggestInt)

if existsEnv("AoC_TEST"):
  var prog = readFile("input.txt")
  var beam = NewBeam(prog)
  assert beam.part1() == 211
  beam.size = 5
  assert beam.inBeam(36, 45)
  assert beam.squareFits(36, 45)
  assert beam.squareFitsY(45) == 36
  assert beam.part2() == 360045

var file = "input.txt"
if paramCount() > 0:
  file=paramStr(1)

var beam = NewBeam(readFile(file))
echo "Part 1: ", beam.part1()
echo "Part 2: ", beam.part2()
