import aoclib

var inp = readInputLists()

var p1:int64 = 0
for e in inp:
  var cc = e[4].count(e[2][0])
  if parseInt(e[0]) <= cc and cc <= parseInt(e[1]):
    p1 += 1

echo "Part 1: ", p1

var p2:int64 = 0
for e in inp:
  var c1 = e[4][parseInt(e[0])-1]
  var c2 = e[4][parseInt(e[1])-1]
  if c1 != c2 and (c1 == e[2][0] or c2 == e[2][0]):
    p2 += 1

echo "Part 2: ", p2
