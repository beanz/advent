import aoclib

proc fuel(m: uint): int =
  result = int(float64(m)/3) - 2

proc fuelr(m: uint) : uint =
  var tm = m
  result = 0
  while true:
    var f = fuel(tm)
    if f <= 0:
      break
    result += uint(f)
    tm = uint(f)

proc part1(masses: seq[uint]): uint =
  result = foldl(masses, a + uint(fuel(b)), uint(0))

proc part2(masses: seq[uint]): uint =
  result = foldl(masses, a + uint(fuelr(b)), uint(0))

assert part1(@[uint(12)]) == 2
assert part1(@[uint(14)]) == 2
assert part1(@[uint(1969)]) == 654
assert part1(@[uint(100756)]) == 33583
assert part1(@[uint(12),14,1969,100756]) == 34241

assert part2(@[uint(14)]) == 2
assert part2(@[uint(1969)]) == 966
assert part2(@[uint(100756)]) == 50346
assert part2(@[uint(12),14,1969,100756]) == 51316

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var masses = UInts(inp)
  let p1 = part1(masses)
  let p2 = part2(masses)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
