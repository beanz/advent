import strutils, sequtils

var inp: seq[int64] = readLine(stdin).split(',').map(parseBiggestInt)

proc part1(inp: seq[int64]): int64 =
  return 1

proc part2(inp: seq[int64]): int64 =
  return 2

assert part1(@[int64(1),0,0,0,99]) == 1

echo "Part 1: ", part1(inp)

echo "Part 2: ", part2(inp)
