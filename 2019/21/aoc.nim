import input, intcode, os, deques

proc runscript(prog : seq[int64], script : string) : int64 =
  var ic = NewIntCode(prog, script)
  let outp = ic.RunToHalt()
  var s = ""
  for ch in outp:
    if ch > 127:
      return ch
    s.add(char(ch))
  echo s
  return -1

proc part1(prog: seq[int64]): int64 =
  # (!C && D) || !A
  return runscript(prog, "NOT C J\nAND D J\nNOT A T\nOR T J\nWALK\n")

proc part2(prog: seq[int64]): int64 =
  # (!A || ( (!B || !C) && H ) ) && D
  return  runscript(prog,
     "NOT B T\nNOT C J\nOR J T\nAND H T\nNOT A J\nOR T J\nAND D J\nRUN\n");

var file = "input.txt"
if paramCount() > 0:
  file=paramStr(1)

var prog = readInts(file)
echo "Part 1: ", part1(prog)
echo "Part 2: ", part2(prog)
