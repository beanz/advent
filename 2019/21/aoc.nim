import aoclib, intcode

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

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var prog = inp.strip(chars = {'\n'}).split(",").map(parseBiggestInt).mapIt(it.int64)
  let p1 = part1(prog)
  let p2 = part2(prog)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
