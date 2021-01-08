import aoclib

type HHInst = tuple
  op: string
  arg: int

type HandHeld = object
    ip : int
    acc : int
    prog : seq[HHInst]

proc NewHandHeld(inp : seq[string]) : HandHeld =
  var prog : seq[HHInst] = @[]
  for istr in inp:
    var ss = istr.split(" ")
    prog.add((op: ss[0], arg: parseInt(ss[1])))
  return HandHeld(ip: 0, acc: 0, prog: prog)

method run(s: var HandHeld) : bool {.base.} =
  var seen = initIntSet()
  s.ip = 0
  s.acc = 0
  while not seen.contains(s.ip) and s.ip < s.prog.len:
    seen.incl(s.ip)
    var inst = s.prog[s.ip]
    case inst.op
    of "acc":
      s.acc += inst.arg
    of "jmp":
      s.ip += inst.arg - 1
    s.ip += 1
  return s.ip >= s.prog.len

method part1(s: var HandHeld) : int {.base.} =
  discard s.run()
  return s.acc

method part2(s: var HandHeld) : int {.base.} =
  for i in countup(0, s.prog.len-1):
    var inst = s.prog[i]
    case inst.op
    of "nop":
      s.prog[i] = (op: "jmp", arg: inst.arg)
      if s.run():
        break
      s.prog[i] = (op: "nop", arg: inst.arg)
    of "jmp":
      s.prog[i] = (op: "nop", arg: inst.arg)
      if s.run():
        break
      s.prog[i] = (op: "jmp", arg: inst.arg)
  return s.acc

var hh = NewHandHeld(readInputLines())

echo "Part 1: ", hh.part1()
echo "Part 2: ", hh.part2()
