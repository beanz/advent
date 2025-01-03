import aoclib, intcode

proc part1(prog: seq[int64]): int64 =
  var ic = NewIntCode(prog, 1)
  return ic.RunToFinalOutput()

proc part2(prog: seq[int64], input: int64): int64 =
  var ic = NewIntCode(prog, input)
  return ic.RunToFinalOutput()

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

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var prog = inp.strip(chars = {'\n'}).split(",").map(parseBiggestInt).mapIt(it.int64)
  let p1 = part1(prog)
  let p2 = part2(prog, 5)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
