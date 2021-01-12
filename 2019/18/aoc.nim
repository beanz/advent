import aoclib, heapqueue

type SearchRecord = object
  pos : Point
  steps : int
  remaining : int
  path : string
  sortedPath : string

proc `<`(a: SearchRecord, b: SearchRecord) : bool = a.remaining < b.remaining

type QuadRecord = object
  p : Point
  name : char

type Rogue = object
  m : Table[Point, char]
  bb : BoundingBox
  pos : Point
  keys : int
  quadkeys : Table[char, HashSet[char]]

proc initRogue(inp : seq[string]) : Rogue =
  var m = initTable[Point, char]()
  var bb = NewBoundingBox()
  bb.Add(Point(x: 0, y: 0))
  bb.Add(Point(x: inp[0].len-1, y: inp.len-1))
  var pos = Point(x: -1, y: -1)
  var keys = 0
  var quadkeys = initTable[char, HashSet[char]]()
  for y, line in inp.pairs:
    for x, chro in line.pairs:
      var ch = chro
      var p = Point(x: x, y: y)
      if ch == '@':
        pos = p
        ch = '.'
      elif 'a' <= ch and ch <= 'z':
        keys += 1
      m[p] = ch
  return Rogue(m: m, bb: bb, pos: pos, keys: keys, quadkeys: quadkeys)

proc `$`(r: Rogue): string =
  var s = ""
  for y in countup(r.bb.mini.y, r.bb.maxi.y):
    for x in countup(r.bb.mini.x, r.bb.maxi.x):
      if x == r.pos.x and y == r.pos.y:
        s &= "@"
      else:
        s &= r.m[Point(x: x, y: y)]
    s &= "\n"
  return s

method optimaze(r: var Rogue) : void =
  var changes = 1
  while changes > 0:
    changes = 0
    for y in countup(r.bb.mini.y, r.bb.maxi.y):
      for x in countup(r.bb.mini.x, r.bb.maxi.x):
        var p = Point(x: x, y: y)
        if r.m[p] != '.':
          continue
        if r.pos.x == x and r.pos.y == y:
          continue
        var nw = 0
        for np in p.neighbours():
          if r.m[np] == '#':
            nw += 1
        if nw > 2:
          r.m[p] = '#'
          changes += 1
  return

method isKeyInQuad(r: Rogue, key : char, quad: char) : bool =
  if quad == '*':
    return true
  if not r.quadkeys.hasKey(quad):
    raise newException(ValueError, "unexpected quad: " & quad)
  return r.quadkeys[quad].contains(key)

method findKeys(r: var Rogue, pos : Point, quad: char) : int =
  r.quadkeys[quad] = initHashSet[char]()
  var visited = initHashSet[Point]()
  var search = initDeque[Point]()
  search.addLast(pos)
  while search.len > 0:
    var cur = search.popFirst
    var ch = r.m[cur]
    if ch == '#':
      continue
    if visited.contains(cur):
      continue
    visited.incl(cur)
    if 'a' <= ch and ch <= 'z':
      if debug(): echo "putting key ", ch, " in ", quad
      r.quadkeys[quad].incl(ch)
    for np in cur.neighbours():
      search.addLast(np)

method find(r: var Rogue, pos: Point, quad : char) : int =
  var expectedKeys = if quad == '*': r.keys else: r.quadkeys[quad].len
  if debug(): echo "find ", expectedKeys, " in ", quad
  var visited = initTable[string, int]()
  var q = initHeapQueue[SearchRecord]()
  var sr = SearchRecord(pos: pos, steps: 0, remaining: expectedKeys,
                        path: "", sortedPath : "")
  q.push(sr)
  var mn = 2147483647
  while q.len > 0:
    var cur = q.pop
    var ch = r.m[cur.pos]
    if ch == '#':
      continue
    if cur.steps > mn:
      continue
    if 'A' <= ch and ch <= 'Z':
      var lch = chr(ord(ch)+32) # lower case
      if cur.path.find(lch) == -1 and r.isKeyInQuad(lch, quad):
        continue
    elif 'a' <= ch and ch <= 'z':
      if cur.path.find(ch) == -1:
        cur.remaining -= 1
        cur.path &= ch
        cur.sortedPath = cur.path
        cur.sortedPath.sort(cmp)
        if cur.remaining == 0:
          if debug():
            echo "found all keys via ", cur.path, " in ", cur.steps, " steps"
          if mn > cur.steps:
            mn = cur.steps
          continue
    var vkey = $(cur.pos.x) & "!" & $(cur.pos.y) & "!" & cur.sortedPath
    if visited.contains(vkey) and visited[vkey] <= cur.steps:
      continue
    visited[vkey] = cur.steps
    for np in cur.pos.neighbours():
      if r.m[np] == '#':
        continue
      var nsr = SearchRecord(pos: np, steps: cur.steps+1,
                             remaining: cur.remaining,
                             path: cur.path, sortedPath : cur.sortedPath)
      q.push(nsr)
  return mn

method part1(r: var Rogue) : int =
  return r.find(r.pos, '*')

method part2(r: var Rogue) : int =
  for np in r.pos.neighbours():
    r.m[np] = '#'
  var sum = 0
  for qr in @[QuadRecord(p: Point(x: -1, y: -1), name: 'A'),
              QuadRecord(p: Point(x:  1, y: -1), name: 'B'),
              QuadRecord(p: Point(x: -1, y:  1), name: 'C'),
              QuadRecord(p: Point(x:  1, y:  1), name: 'D')]:
    var start = Point(x: r.pos.x + qr.p.x, y: r.pos.y + qr.p.y)
    var quad = qr.name
    discard r.findKeys(start, quad)
    sum += r.find(start, quad)
  return sum

var inp = readInputLines()
var rogue = initRogue(inp)
rogue.optimaze()
echo "Part 1: ", rogue.part1()
echo "Part 2: ", rogue.part2()
