import deques

type Inst = object
    op: int64
    param: array[3, int64]
    address: array[3, int64]

type IntCode* = object
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

proc NewIntCode*(cprog : seq[int64], inputs: varargs[int64]): IntCode =
    var prog: seq[int64]
    deepCopy(prog, cprog)
    var inp = initDeque[int64]()
    for input in inputs:
      inp.addLast(input)
    return IntCode(ip: 0, p: prog, base: 0,
                   inp: inp, outp: initDeque[int64](), done: false)

proc NewIntCode*(cprog : seq[int64], input: string): IntCode =
    var prog: seq[int64]
    deepCopy(prog, cprog)
    var inp = initDeque[int64]()
    for ch in input:
      inp.addLast(ord(ch))
    return IntCode(ip: 0, p: prog, base: 0,
                   inp: inp, outp: initDeque[int64](), done: false)

method CloneWithInput*(this: IntCode, input: int64): IntCode {.base.} =
  var prog: seq[int64]
  deepCopy(prog, this.p)
  var ic = IntCode(ip: this.ip,
                   p: prog,
                   base: this.base, inp: initDeque[int64](),
                   outp: initDeque[int64](),
                   done: false)
  ic.inp.addLast(input)
  return ic

proc GetIntCodeRef*[IntCode](x: IntCode): ref IntCode =
  new(result); result[] = x

method sprog(this: var IntCode, i: int64): int64 {.base.} =
  while len(this.p) <= i:
    this.p.add(0)
  return this.p[i]

method parseInst(this: var IntCode): Inst {.base.} =
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

method Run*(this: var IntCode): int64 {.base.} =
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
        this.ip -= (opArity(inst.op)+1) # backup to run again
        #echo "3: input exhausted"
        return 2
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

method RunToHalt*(this: var IntCode): Deque[int64] {.base.} =
  while not this.done:
    discard this.Run()
  return this.outp

method RunToFinalOutput*(this: var IntCode): int64 {.base.} =
  let outp = this.RunToHalt()
  return outp[len(outp)-1]

type IntCodeInputFunction = proc() : int64 {.closure}
type IntCodeOutputFunction = proc(ints: seq[int64]) {.closure.}

method RunWithCallbacks*(this: var IntCode,
                         infn: IntCodeInputFunction,
                         outfn: IntCodeOutputFunction,
                         outn : int64): bool {.base.} =
    while not this.done:
      let rc = this.Run()
      case rc
      of 0:
        if len(this.outp) == outn:
          var o : seq[int64]
          for i in countup(int64(1), outn):
            o.add(this.outp.popFirst)
          outfn(o)
        continue
      of 1:
        return true
      of 2:
        this.inp.addLast(infn())
        continue
      else:
        echo "IntCode error"
        return false

method Output*(this: var IntCode, n : int): seq[int64] {.base.} =
  var res : seq[int64]
  if len(this.outp) >= n:
    for i in countup(1, n):
      res.add(this.outp.popFirst)
  return res

method OutputString*(this: var IntCode): string {.base.} =
  var s = ""
  for x in this.outp.items():
    s &= chr(x)
  this.outp.clear
  return s

method NextOutput*(this: var IntCode): int64 {.base.} =
  if len(this.outp) > 0:
    return this.outp.popFirst
  while not this.done:
    discard this.Run()
    if len(this.outp) > 0:
      return this.outp.popFirst
  return -99

method AddInput*(this: var IntCode, inputs: varargs[int64]): void {.base.} =
  for input in inputs:
    this.inp.addLast(input)

method AddInput*(this: var IntCode, input: string): void {.base.} =
  for c in input:
    this.inp.addLast(c.ord)

method Done*(this: var IntCode): bool {.base.} =
  return this.done
