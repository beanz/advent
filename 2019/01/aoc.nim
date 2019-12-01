import strutils, sequtils

proc fuel(m: uint64): int64 =
  result = int64(float64(m)/3) - 2

proc fuelr(m: uint64) : uint64 =
  var tm = m
  result = 0
  while true:
    var f = fuel(tm)
    if f <= 0:
      break
    result += uint64(f)
    tm = uint64(f)

var masses: seq[uint64]
for line in stdin.lines:
  masses.add(line.parseBiggestUInt())

proc part1(masses: seq[uint64]): uint64 =
  result = foldl(masses, a + uint64(fuel(b)), uint64(0))

proc part2(masses: seq[uint64]): uint64 =
  result = foldl(masses, a + uint64(fuelr(b)), uint64(0))

assert part1(@[uint64(12)]) == 2
assert part1(@[uint64(14)]) == 2
assert part1(@[uint64(1969)]) == 654
assert part1(@[uint64(100756)]) == 33583
assert part1(@[uint64(12),14,1969,100756]) == 34241

echo "Part 1: ", part1(masses)

assert part2(@[uint64(14)]) == 2
assert part2(@[uint64(1969)]) == 966
assert part2(@[uint64(100756)]) == 50346
assert part2(@[uint64(12),14,1969,100756]) == 51316

echo "Part 2: ", part2(masses)
