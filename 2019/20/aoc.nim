import aoclib, point

type Portal = object
    exit: Point
    name: string
    level: int

type Search = object
    pos: Point
    steps: int
    level: int
    path: string

method vkey(this: var Search): string {.base.} =
  return $this.pos.x & "," & $this.pos.y & "_" & $this.level

type Donut = object
    walls: Table[Point, bool]
    portals: Table[Point, Portal]
    bb: BoundingBox
    start: Point
    exit: Point

proc NewDonut(lines : seq[string]): Donut =
  var walls = initTable[Point, bool]()
  var portals = initTable[Point, Portal]()
  var bb = NewBoundingBox()
  var start = Point(x: -1, y: -1)
  var exit = Point(x: -1, y: -1)
  bb.Add(Point(x: 0, y: 0))
  bb.Add(Point(x: len(lines[0])-1, y: len(lines)-1))
  var rp = initTable[string, Point]()
  proc isPortal(x: int, y: int) : bool =
    return 'A' <= lines[y][x] and lines[y][x] <= 'Z'
  proc addPortal(p : Point, bx: int, by: int, ch1: char, ch2 : char) =
    let name : string = ch1 & ch2
    walls[Point(x: bx, y: by)] = true
    if name == "AA":
      start = p
      return
    if name == "ZZ":
      exit = p
      return
    var level = 1
    if p.y == bb.mini.y+2 or p.y == bb.maxi.y-2 or
       p.x == bb.mini.x+2 or p.x == bb.maxi.x-2:
      level = -1
    if rp.hasKey(name):
      let ex = rp[name]
      portals[p] = Portal(exit: ex, name: name, level: level)
      portals[ex] = Portal(exit: p, name: name, level: -1*level)
      rp.del(name)
    else:
      rp[name] = p

  for y in countup(bb.mini.y, bb.maxi.y):
    for x in countup(bb.mini.x, bb.maxi.x):
      let p = Point(x: x, y: y)
      if lines[y][x] == '#':
        walls[p] = true
      elif lines[y][x] == '.':
        if isPortal(x,y-2) and isPortal(x, y-1):
          addPortal(p, x, y-1, lines[y-2][x], lines[y-1][x])
        elif (isPortal(x, y+1) and isPortal(x, y+2)):
          addPortal(p, x, y+1, lines[y+1][x], lines[y+2][x])
        elif (isPortal(x-2, y) and isPortal(x-1, y)):
          addPortal(p, x-1, y, lines[y][x-2], lines[y][x-1])
        elif (isPortal(x+1, y) and isPortal(x+2, y)):
          addPortal(p, x+1, y, lines[y][x+1], lines[y][x+2])
  if len(rp) != 0:
    echo "some portals are not connected", rp
    assert false
  return Donut(walls: walls, portals: portals,
               bb: bb, start: start, exit: exit)

method String(this: var Donut): string {.base.} =
  var s = newString((1+this.bb.maxi.x-this.bb.mini.x)*
                    (1+this.bb.maxi.y-this.bb.mini.y))
  for y in countup(this.bb.mini.y, this.bb.maxi.y):
    for x in countup(this.bb.mini.x, this.bb.maxi.x):
      let p = Point(x: x, y: y)
      if this.start == p:
        s.add('S')
      elif this.exit == p:
        s.add('E')
      elif this.portals.hasKey(p):
        s.add('~')
      elif this.walls.hasKey(p):
        s.add('#')
      else:
        s.add('.')
    s.add('\n')
  return s

method search(this: Donut, recurse: bool): int {.base.} =
  var search = initDeque[Search]()
  search.addLast(Search(pos: this.start, steps: 0, level: 0, path: ""))
  var visited = initTable[string, bool]()
  while len(search) > 0:
    var cur = search.popFirst
    if this.walls.hasKey(cur.pos):
      continue
    let vkey = cur.vkey()
    if visited.hasKey(vkey):
      continue
    visited[vkey] = true
    if cur.level == 0 and
       cur.pos.x == this.exit.x and cur.pos.y == this.exit.y:
      return cur.steps
    if this.portals.hasKey(cur.pos):
      let portal = this.portals[cur.pos]
      var nlevel = cur.level
      if recurse:
        nlevel += portal.level
      if nlevel >= 0:
        var npath : string
        if cur.path == "":
          npath = portal.name
        else:
          npath = cur.path & " " & portal.name
        search.addLast(Search(pos: portal.exit,
                              steps: cur.steps+1,
                              level: nlevel,
                              path: npath))
    for np in cur.pos.neighbours():
      search.addLast(Search(pos: np,
                            steps: cur.steps+1,
                            level: cur.level,
                            path: cur.path))
  return -1

method part1(this: Donut): int {.base.} =
  return this.search(false)

method part2(this: Donut): int {.base.} =
  return this.search(true)

if false:
  assert NewDonut(aoclib.readLines("test1a.txt")).part1() == 23;
  assert NewDonut(aoclib.readLines("test1b.txt")).part1() == 58;
  assert NewDonut(aoclib.readLines("input.txt")).part1() == 482;

  assert NewDonut(aoclib.readLines("test1a.txt")).part2() == 26;
  assert NewDonut(aoclib.readLines("test2a.txt")).part2() == 396;
  assert NewDonut(aoclib.readLines("input.txt")).part2() == 5912;
  echo "TESTS PASSED"

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var donut = NewDonut(Lines(inp))
  let p1 = donut.part1()
  let p2 = donut.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
