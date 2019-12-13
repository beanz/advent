import strutils, sequtils, deques
var prog: seq[int64] = readLine(stdin).split(',').map(parseBiggestInt)

type Inst = object
    op: int64
    param: array[3, int64]
    address: array[3, int64]

type InputFunction = proc() : int64 {.closure}
type OutputFunction = proc(x : int64, y : int64, t : int64) {.closure}

type IntComp = object
    ip: int64
    base: int64
    p: seq[int64]
    infn: InputFunction
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
      this.p[inst.address[0]] = this.infn()
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

proc run(prog: seq[int64], inf: InputFunction, outfn: OutputFunction) =
  var outp = initDeque[int64]()
  var ic = IntComp(ip: 0, p: prog, base: 0, infn: inf, outp: outp,
                   done: false)
  while not ic.done:
    let rc = ic.run()
    if len(ic.outp) == 3:
      outfn(ic.outp.popFirst, ic.outp.popFirst, ic.outp.popFirst)
  return

proc part1(prog_c: seq[int64]): int64 =
  var prog: seq[int64]
  deepCopy(prog, prog_c)
  var blocks = 0
  proc noInput() : int64 =
    return 0
  proc countBlocks(x : int64, y : int64, t : int64) =
    if t == 2:
      blocks += 1
  run(prog, noInput, countBlocks)
  return blocks

proc part2(prog_c: seq[int64]): int64 =
  var prog: seq[int64]
  deepCopy(prog, prog_c)
  prog[0] = 2
  var ball : int64 = 0
  var paddle : int64 = 0
  var score : int64 = 0
  proc joystickInput() : int64 =
    if ball < paddle:
      return -1
    elif ball > paddle:
      return 1
    else:
      return 0
  proc playBreakout(x : int64, y : int64, t : int64) =
    if x == -1 and y == 0:
      score = t
    elif t == 3:
      paddle = x
    elif t == 4:
      ball = x

  run(prog, joystickInput, playBreakout)
  return score

echo "Part 1: ", part1(prog)
echo "Part 2: ", part2(prog)
