import strutils, sequtils, deques

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

proc run(prog_c: seq[int64], input: int64): string =
  var prog: seq[int64]
  deepCopy(prog, prog_c)
  var inp = initDeque[int64]()
  inp.addLast(input)
  var outp = initDeque[int64]()
  var ic = IntComp(ip: 0, p: prog, base: 0, inp: inp, outp: outp,
                   done: false)
  while not ic.done:
    let rc = ic.run()
  var res = replace($ic.outp, " ", "")
  return res[1 .. len(res)-2]

proc part1(prog: seq[int64]): string =
  return run(prog, 1)

proc part2(prog: seq[int64]): string =
  return run(prog, 2)

assert opArity(1) == 3;
assert opArity(2) == 3;
assert opArity(3) == 1;
assert opArity(4) == 1;
assert opArity(5) == 2;
assert opArity(6) == 2;
assert opArity(7) == 3;
assert opArity(8) == 3;
assert opArity(9) == 1;
assert opArity(99) == 0;

assert part1(@[int64(109),1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,
           99]) == "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
assert part1(@[int64(1102),34915192,34915192,7,4,7,99,0]) == "1219070632396864"
assert part1(@[int64(104),1125899906842624,99]) == "1125899906842624"

echo "Tests PASSED"

echo "Part 1: ", part1(prog)
echo "Part 2: ", part2(prog)
