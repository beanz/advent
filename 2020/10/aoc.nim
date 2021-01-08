import aoclib

proc part1(inp : seq[int]) : int =
  var c1 = 0
  var c3 = 0
  var prev = 0
  for v in inp:
    var d = v-prev
    case d
    of 1:
      c1 += 1
    of 3:
      c3 += 1
    else:
      discard
    prev = v
  return c1 * c3

proc part2(inp : seq[int]) : int =
  var inc = toSeq(0 .. inp[inp.len-1]).map(x => inp.count(x))
  var trib = initDeque[int]()
  trib.addLast(0)
  trib.addLast(0)
  trib.addLast(1)
  for e in inc:
    var s = trib.toseq.foldl(a + b)
    discard trib.popFirst
    trib.addLast(s * e)
  return trib.popLast

var inp = readInputInts()
inp.sort()
inp.add(inp[inp.len-1] + 3)

echo inp.count(6)
echo "Part 1: ", part1(inp)
echo "Part 2: ", part2(inp)
