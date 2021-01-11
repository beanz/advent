import aoclib

var inp = readInputLines()[0].split("-").map(parseBiggestInt)

proc count(s: string, ch: char): int =
  var c = 0
  for i in 0..<s.len:
    if s[i] == ch:
      c += 1
  return c

proc part1(inp: seq[int64]): int64 =
  var c = 0
  for i in countup(inp[0], inp[1]):
    let s = fmt"{i}"
    if len(s) != 6:
      continue
    if s[0] > s[1] or s[1] > s[2] or s[2] > s[3] or s[3] > s[4] or s[4] > s[5]:
      continue
    for ch in ['0','1','2','3','4','5','6','7','8','9']:
      if (count(s, ch) >= 2):
        c += 1
        break

  return c

proc part2(inp: seq[int64]): int64 =
  var c = 0
  for i in countup(inp[0], inp[1]):
    let s = fmt"{i}"
    if len(s) != 6:
      continue
    if s[0] > s[1] or s[1] > s[2] or s[2] > s[3] or s[3] > s[4] or s[4] > s[5]:
      continue
    for ch in ['0','1','2','3','4','5','6','7','8','9']:
      if (count(s, ch) == 2):
        c += 1
        break

  return c

assert part1(@[int64(111111),111111]) == 1
assert part1(@[int64(223450),223450]) == 0
assert part1(@[int64(123789),123789]) == 0
assert part1(@[int64(123444),123444]) == 1
assert part1(@[int64(111122),111122]) == 1

echo "Part 1: ", part1(inp)

assert part2(@[int64(112233),112233]) == 1
assert part2(@[int64(123444),123444]) == 0
assert part2(@[int64(111122),111122]) == 1

echo "Part 2: ", part2(inp)
