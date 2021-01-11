import aoclib, intcode

type Beam = object
    prog: seq[int64]
    size: int64
    ratio1: int64
    ratio2: int64
    divisor: int64

proc NewBeam(c_prog : seq[int64]) : Beam =
  var prog: seq[int64]
  deepCopy(prog, c_prog)
  return Beam(prog: prog, size: 100, ratio1: 0, ratio2: 0, divisor: 0)

method inBeam(this: var Beam, x : int64, y: int64): bool {.base.} =
    var ic = NewIntCode(this.prog, x, y)
    return ic.NextOutput == 1

method part1(this: var Beam): int64 {.base.} =
  var count : int64 = 0
  var first : int64 = -1
  var last : int64 = -1
  for y in countup(int64(0), 49):
    first = -1
    last = -1
    for x in countup(int64(0), 49):
      if this.inBeam(x, y):
        if first == -1:
          first = x
        last = x
        count += 1
  this.ratio1 = first
  this.ratio2 = last
  this.divisor = 49
  return count

method squareFits(this: var Beam, x : int64, y : int64) : bool {.base.} =
  return(this.inBeam(x,y) and
         this.inBeam(x+this.size-1,y) and
         this.inBeam(x, y+this.size-1))

method squareFitsY(this: var Beam, y : int64) : int64 {.base.} =
  var xmin = (y * this.ratio1 div this.divisor)
  var xmax = (y * this.ratio2 div this.divisor)
  for x in countup(xmin, xmax):
    if this.squareFits(x, y):
      return x
  return 0

method part2(this: var Beam): int64 {.base.} =
  var upper : int64 = 1
  while this.squareFitsY(upper) == 0:
    upper *= 2
  var lower = upper div 2
  while true:
    var mid = (lower + upper) div 2
    if mid == lower:
      break
    if this.squareFitsY(mid) > 0:
      upper = mid
    else:
      lower = mid
  for y in countup(lower, lower + 5):
    var x = this.squareFitsY(y)
    if x > 0:
      return x*10000 + y
  return -1

if runTests():
  var prog = readInt64s("input.txt")
  var beam = NewBeam(prog)
  assert beam.part1() == 211
  beam.size = 5
  assert beam.inBeam(36, 45)
  assert beam.squareFits(36, 45)
  assert beam.squareFitsY(45) == 36
  assert beam.part2() == 360045

var beam = NewBeam(readInputInt64s())
echo "Part 1: ", beam.part1()
echo "Part 2: ", beam.part2()
