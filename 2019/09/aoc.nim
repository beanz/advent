import aoclib, intcode

proc run(prog: seq[int64], input: int64): string =
  var ic = NewIntCode(prog, input)
  let outp = ic.RunToHalt()
  var res = replace($outp, " ", "")
  return res[1 .. len(res)-2]

proc part1(prog: seq[int64]): string =
  return run(prog, 1)

proc part2(prog: seq[int64]): string =
  return run(prog, 2)

if runTests():
  assert part1(@[int64(109),1,204,-1,1001,100,1,100,1008,100,16,101,
                 1006,101,0,
                 99]) ==
     "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
  assert part1(@[int64(1102),34915192,34915192,7,4,7,99,
                 0]) == "1219070632396864"
  assert part1(@[int64(104),1125899906842624,99]) == "1125899906842624"
  echo "Tests PASSED"

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var prog = inp.strip(chars = {'\n'}).split(",").map(parseBiggestInt).mapIt(it.int64)
  let p1 = part1(prog)
  let p2 = part2(prog)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
