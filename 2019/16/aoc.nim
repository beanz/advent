import aoclib

let REP = [0, 1, 0, -1]

proc calc1(s : seq[uint8]): seq[uint8] =
  var o : seq[uint8]
  for i in countup(1, len(s)):
    var n : int64 = 0
    for j in countup(0, len(s)-1):
      let di = (1 + j) div i
      let m = REP[di mod 4]
      var d = cast[int64](s[j]) * m
      n += d
    if n < 0:
      n *= -1
    n = n mod 10
    o.add(cast[uint8](n))
  return o

proc digits(s : seq[uint8], n : int): string =
  var str = ""
  for i in countup(0, n-1):
    str.add(cast[char](s[i] + 48))
  return str

proc part1(inp: seq[uint8], phases: int): string =
  var s = inp
  for ph in countup(1, phases):
    s = calc1(s)
    #echo "Phase ", ph, " Signal: ", digits(s, 8)
  return digits(s, 8)

proc offset(s : seq[uint8], n : int64): int64 =
  var r : int64 = 0
  for i in countup(cast[int64](0), n-1):
    r *= 10
    r += cast[int64](s[i])
  return r

proc calc2(s : seq[uint8]): seq[uint8] =
  var o : seq[uint8]
  var ps : int64 = 0
  for i in countup(0, len(s)-1):
    ps += cast[int64](s[i])
  for i in countup(0, len(s)-1):
    var n = ps
    if n < 0:
      n *= -1
    n = n mod 10
    o.add(cast[uint8](n))
    ps -= cast[int64](s[i])
  return o

proc part2(inp: seq[uint8]): string =
  var off = offset(inp, 7)
  var s : seq[uint8] = inp.cycle(10000)
  s = s[off..<s.len]
  for ph in countup(1, 100):
    s = calc2(s)
  return digits(s, 8)

if runTests():
  echo "Running tests"
  assert part1(readUInt8s("test1a.txt"), 4) == "01029498"
  assert part1(readUInt8s("test1b.txt"), 100) == "24176176"
  assert part1(readUInt8s("test1c.txt"), 100) == "73745418"
  assert part1(readUInt8s("test1d.txt"), 100) == "52432133"
  assert part2(readUInt8s("test2a.txt")) == "84462026"
  assert part2(readUInt8s("test2b.txt")) == "78725270"
  assert part2(readUInt8s("test2c.txt")) == "53553731"
  echo "Tests PASSED"

var inp: seq[uint8] = readInputUInt8s()
echo "Part 1: ", part1(inp, 100)
echo "Part 2: ", part2(inp)
