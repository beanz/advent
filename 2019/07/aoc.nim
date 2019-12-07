import strutils, sequtils, deques, algorithm

var prog: seq[int64] = readLine(stdin).split(',').map(parseBiggestInt)

type Inst = object
    op: int64
    param: array[3, int64]
    address: array[3, int64]

type IntComp = object
    ip: int64
    p: seq[int64]
    inp: Deque[int64]
    outp: Deque[int64]
    done: bool
    name: string

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
    of 99:
      this.done = true
      return 1
    else:
      this.done = true
      return -1
  this.done = true
  return -2

proc tryPhase(prog_c: seq[int64], phase: seq[int64]): int64 =
  var u: seq[IntComp]
  for i in countup(0, len(phase)-1):
    var prog: seq[int64]
    deepCopy(prog, prog_c)
    var inp = initDeque[int64]()
    inp.addLast(phase[i])
    var outp = initDeque[int64]()
    let g = IntComp(ip: 0, p: prog, inp: inp, outp: outp,
                    done: false, name: $i)
    u.add(g)
  var done : int64 = 0
  var last : int64 = 0
  var output : int64 = 0
  var first = true
  while done < len(phase):
    done = 0
    for i in countup(0, len(phase)-1):
      if u[i].done:
        done += 1
      else:
        if not first:
          u[i].inp.addLast(output)
        first = false
        var rc = u[i].run()
        if len(u[i].outp) != 0:
          output = u[i].outp.popFirst
          last = output
          #echo i, ": received ", output, " (", rc, ")"
        if rc != 0:
          done += 1
  return last

proc run(prog: seq[int64], minPhase: int64): int64 =
  var perm = @[minPhase, minPhase+1, minPhase+2, minPhase+3, minPhase+4]
  var max = -2147483648
  while true:
    var thrust = tryPhase(prog, perm)
    if max < thrust:
      max = thrust
    if not perm.nextPermutation():
      break
  return max

proc part1(prog: seq[int64]): int64 =
  return run(prog, 0)

proc part2(prog: seq[int64]): int64 =
  return run(prog, 5)

assert opArity(1) == 3;
assert opArity(2) == 3;
assert opArity(3) == 1;
assert opArity(4) == 1;
assert opArity(5) == 2;
assert opArity(6) == 2;
assert opArity(7) == 3;
assert opArity(8) == 3;
assert opArity(99) == 0;

assert try_phase(@[int64(3),15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0],
                 @[int64(4),3,2,1,0]) == 43210
assert part1(@[int64(3),15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]) == 43210
assert part1(@[int64(3),23,3,24,1002,24,10,24,1002,23,-1,23,
           101,5,23,23,1,24,23,23,4,23,99,0,0]) == 54321
assert part1(@[int64(3),31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
           1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]) == 65210
assert part2(@[int64(3),26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
           27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]) == 139629729
assert part2(@[int64(3),52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,
               1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,
               55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,
               99,0,0,0,0,10]) == 18216

echo "Part 1: ", part1(prog)
echo "Part 2: ", part2(prog)
