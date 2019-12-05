import strutils, sequtils

var prog: seq[int64] = readLine(stdin).split(',').map(parseBiggestInt)

type Inst = object
    op: int64
    param: array[3, int64]
    address: array[3, int64]

type IntComp = object
    p: seq[int64]
    ip: int64
    output: seq[int64]

proc opArity(op: int64): int64 =
  if op == 99:
    return 0
  return [0,3,3,1,1,2,2,3,3,][op]

method parseInst(this: var IntComp): Inst {.base.} =
  var rawOp = this.p[this.ip]
  this.ip += 1
  var inst = Inst(op: (rawOp mod 100))
  let immediate: array[3,bool] = [
      (rawOp div 100) mod 10 == 1,
      (rawOp div 1000) mod 10 == 1,
      (rawOp div 10000) mod 10 == 1]
  for i in countup(int64(0), opArity(inst.op)-1):
    if immediate[i]:
      inst.param[i] = this.p[this.ip]
      inst.address[i] = -99
    else:
      inst.param[i] = this.p[this.p[this.ip]]
      inst.address[i] = this.p[this.ip]
    this.ip += 1
  return inst

method run(this: var IntComp, input: int64): bool {.base.} =
  this.ip = 0
  var l : int64 = len(this.p)
  while this.ip < l:
    let inst = this.parseInst()
    case inst.op
    of 1:
      this.p[inst.address[2]] = inst.param[0] + inst.param[1]
    of 2:
      this.p[inst.address[2]] = inst.param[0] * inst.param[1]
    of 3:
      this.p[inst.address[0]] = input
    of 4:
      this.output.add(inst.param[0])
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
    of 99:
      return true
    else:
      return false
  return false

proc part1(prog_c: seq[int64]): int64 =
  var prog: seq[int64]
  deepCopy(prog, prog_c)
  var c = IntComp(ip: 0, p: prog)
  let b = c.run(1)
  return c.output[len(c.output)-1]

proc part2(prog_c: seq[int64], input: int64): int64 =
  var prog: seq[int64]
  deepCopy(prog, prog_c)
  var c = IntComp(ip: 0, p: prog)
  let b = c.run(input)
  return c.output[0]

assert opArity(1) == 3;
assert opArity(2) == 3;
assert opArity(3) == 1;
assert opArity(4) == 1;
assert opArity(5) == 2;
assert opArity(6) == 2;
assert opArity(7) == 3;
assert opArity(8) == 3;
assert opArity(99) == 0;

assert part2(@[int64(3), 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], 8) == 1;
assert part2(@[int64(3), 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], 4) == 0;
assert part2(@[int64(3), 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], 7) == 1;
assert part2(@[int64(3), 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], 8) == 0;
assert part2(@[int64(3), 3, 1108, -1, 8, 3, 4, 3, 99], 8) == 1;
assert part2(@[int64(3), 3, 1108, -1, 8, 3, 4, 3, 99], 9) == 0;
assert part2(@[int64(3), 3, 1107, -1, 8, 3, 4, 3, 99], 7) == 1;
assert part2(@[int64(3), 3, 1107, -1, 8, 3, 4, 3, 99], 9) == 0;
assert part2(@[int64(3), 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99,
               -1, 0, 1, 9], 2) == 1;
assert part2(@[int64(3), 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99,
               -1, 0, 1, 9], 0) == 0;
assert part2(@[int64(3), 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99,
               1], 3) == 1;
assert part2(@[int64(3), 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99,
               1], 0) == 0;
assert part2(@[int64(3), 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
               20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20,
               4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20,
               4, 20, 1105, 1, 46, 98, 99], 5) == 999;
assert part2(@[int64(3), 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
               20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20,
               4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20,
               4, 20, 1105, 1, 46, 98, 99], 8) == 1000;
assert part2(@[int64(3), 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
               20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20,
               4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20,
               4, 20, 1105, 1, 46, 98, 99], 9) == 1001;

echo "Part 1: ", part1(prog)
echo "Part 2: ", part2(prog, 5)
