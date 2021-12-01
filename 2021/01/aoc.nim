import aoclib

var ex = readInputInts()

iterator windows*[T](s: openArray[T], n: Positive): seq[T] =
  var i = 0
  while i + n <= len(s):
    yield s[i ..< i+n]
    inc i

var p1 = 0
for pair in windows(ex, 2):
   if pair[0] < pair[1]:
     inc p1

var p2 = 0
for w in windows(ex, 4):
   if w[0] < w[3]:
     inc p2


echo "Part 1: ", p1
echo "Part 2: ", p2
