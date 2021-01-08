import aoclib

var ex = readInputInts()
var hs = toHashSet(ex)

var products = initTable[int64, int64]()

var p1:int64 = 0
for a in ex:
  if hs.contains(2020-a):
    p1 = a*(2020-a)
  for b in ex:
    if a == b:
      continue
    products[a+b] = a*b

var p2:int64 = 0
for a in ex:
  if products.contains(2020-a):
    p2 = a*products[2020-a]
    break

echo "Part 1: ", p1
echo "Part 2: ", p2
