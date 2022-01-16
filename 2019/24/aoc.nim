import aoclib

proc bug(n: int, x: int, y: int): bool =
  if y < 0 or y >= 5 or x < 0 or x >= 5:
    return false
  return (n and (1 shl (y*5+x))) != 0

proc life(n: int, x: int, y: int): bool =
  var c = 0
  if bug(n, x, y-1):
    c += 1
  if bug(n, x-1, y):
    c += 1
  if bug(n, x+1, y):
    c += 1
  if bug(n, x, y+1):
    c += 1
  return c == 1 or (not bug(n, x, y) and c == 2)

proc pp(n: int): string =
  var s = ""
  for y in countup(0, 4):
    for x in countup(0, 4):
      if bug(n, x, y):
        s.add("#")
      else:
        s.add(".")
    s.add("\n")
  return s

proc readbugs(inp: seq[string]): int =
  var i : int = 1
  var n : int = 0
  for y in countup(0, 4):
    for x in countup(0, 4):
      if inp[y][x] == '#':
        n += i
      i = i shl 1
  return n

proc part1(inp: seq[string]): int =
  var n = readbugs(inp)
  var seen = initHashSet[int]()
  while true:
    var new : int = 0
    var i = 1
    for y in countup(0, 4):
      for x in countup(0, 4):
        if life(n, x, y):
          new += i
        i = i shl 1
    #echo new
    #echo pp(new)
    if seen.contains(new):
      return new
    seen.incl(new)
    n = new
  return -1

proc bug2(m: Table[int,int], d: int, x: int, y: int): bool =
  if y < 0 or y >= 5 or x < 0 or x >= 5:
    return false
  let n = m.getOrDefault(d, 0)
  #echo d, " ", x, " ", y, " ", ((n and (1 shl (y*5+x))) != 0)
  return (n and (1 shl (y*5+x))) != 0

proc life2(m: Table[int,int], d: int, x: int, y: int): bool =
  var c = 0

  # neighbour(s) above
  if y == 0:
    if bug2(m, d-1, 2, 1):
      c += 1
  elif y == 3 and x == 2:
    for i in countup(0, 4):
      if bug2(m, d+1, i, 4):
        c += 1
  else:
    if bug2(m, d, x, y-1):
      c += 1

  # neighbour(s) below
  if y == 4:
    if bug2(m, d-1, 2, 3):
      c += 1
  elif y == 1 and x == 2:
    for i in countup(0, 4):
      if bug2(m, d+1, i, 0):
        c += 1
  else:
    if bug2(m, d, x, y+1):
      c += 1

  # neighbour(s) left
  if x == 0:
    if bug2(m, d-1, 1, 2):
      c += 1
  elif x == 3 and y == 2:
    for i in countup(0, 4):
      if bug2(m, d+1, 4, i):
        c += 1
  else:
    if bug2(m, d, x-1, y):
      c += 1

  # neighbour(s) right
  if x == 4:
    if bug2(m, d-1, 3, 2):
      c += 1
  elif x == 1 and y == 2:
    for i in countup(0, 4):
      if bug2(m, d+1, 0, i):
        c += 1
  else:
    if bug2(m, d, x+1, y):
      c += 1

  return c == 1 or ((not bug2(m, d, x, y)) and c == 2)

proc count(m: Table[int,int]): int =
  var c = 0
  for depth in m.keys:
    for y in countup(0, 4):
      for x in countup(0, 4):
        if bug2(m, depth, x, y):
          c += 1
  return c

proc pp2(m: Table[int,int]): string =
  var minD = 100000
  var maxD = -100000
  for d in m.keys:
    maxD = max(d, maxD)
    minD = min(d, minD)
  var s = ""
  for d in countup(minD, maxD):
    s &= "Depth "
    s &= $(d)
    s &= "\n"
    s &= pp(m[d])
  return s

proc part2(inp: seq[string], minutes: int): int =
  var n = readbugs(inp)
  var m = initTable[int,int]()
  m[0] = n
  for t in countup(1, minutes):
    var newM = initTable[int,int]()
    var minD = 100000
    var maxD = -100000
    for d in m.keys:
      maxD = max(d, maxD)
      minD = min(d, minD)
    for d in countup(minD-1, maxD+1):
      var new = 0
      for y in countup(0, 4):
        for x in countup(0, 4):
          if x == 2 and y == 2:
            continue
          if life2(m, d, x, y):
            new += 1 shl (y*5 + x)
      newM[d] = new
    m = newM
  return count(m)

if runTests():
  assert part1(aoclib.readLines("test.txt")) == 2129920
  assert part1(aoclib.readLines("input.txt")) == 6520863
  assert part2(aoclib.readLines("test.txt"), 1) == 27
  assert part2(aoclib.readLines("test.txt"), 10) == 99
  assert part2(aoclib.readLines("input.txt"), 1) == 21
  assert part2(aoclib.readLines("input.txt"), 200) == 1970

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var ls = Lines(inp)
  let p1 = part1(ls)
  let p2 = part2(ls, 200)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
