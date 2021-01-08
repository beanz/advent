import aoclib

proc part1(inp : seq[int], pre : int) : int =
  var sums = initDeque[seq[int]]()
  for i in countup(0, pre-2):
    var sumlist = inp[i+1 .. pre-1].map(x => x + inp[i])
    sums.addLast(sumList)
  for i in countup(pre, inp.len-1):
    var valid = sums.toSeq.any(sl => sl.any(x => x == inp[i]))
    if not valid:
      return inp[i]
    discard sums.popFirst
    for j in countup(0, sums.len-1):
      sums[j].add(inp[i-pre+j+1] + inp[i])
    sums.addLast(@[inp[i-1] + inp[i]])
  return 0

proc part2(inp : seq[int], target : int) : int =
  var si = 0
  var ei = 0
  var s = inp[si..ei].foldl(a + b)
  while s != target or si == (ei-1):
    if s < target:
      ei += 1
      s += inp[ei]
    else:
      s -= inp[si]
      si += 1
  return inp[si..ei].min + inp[si..ei].max

var inp = readInputInts()

var pre = 25
if isTest():
  pre = 5
var p1 = part1(inp, pre)
echo "Part 1: ", p1
echo "Part 2: ", part2(inp, p1)
