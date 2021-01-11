import aoclib, intcode, point

var prog = readInputInt64s()

type Ship = object
    wall : Table[Point, bool]
    bb : BoundingBox
    os : ref Point
    osic : ref IntCode
    steps : int64

method String(this: var Ship): string {.base.} =
  var s = newString(42*42)
  for y in countup(this.bb.mini.y, this.bb.maxi.y):
    for x in countup(this.bb.mini.x, this.bb.maxi.x):
      if x == 0 and y == 0:
        s.add("S")
      elif this.os != nil and this.os.x == x and this.os.y == y:
        s.add("O")
      else:
        let p = Point(x: x, y: y)
        if this.wall.hasKey(p):
          s.add('#')
        else:
          s.add('.')
    s.add('\n')
  return s

proc compassToInput(dir : string) : int64 =
  case dir:
    of "N":
      return 1
    of "S":
      return 2
    of "W":
      return 3
    else:
      return 4

proc compassXOffset(dir : string) : int =
  case dir:
    of "N":
      return 0
    of "S":
      return 0
    of "W":
      return -1
    else:
      return 1

proc compassYOffset(dir : string) : int =
  case dir:
    of "N":
      return -1
    of "S":
      return 1
    of "W":
      return 0
    else:
      return 0

type Search = object
    pos: Point
    steps : int64
    ic: IntCode

proc part1(prog_c: seq[int64]): Ship =
  var search = initDeque[Search]()
  var ship = Ship(wall: initTable[Point,bool](),
                  bb: NewBoundingBox(),
                  os: nil,
                  osic: nil,
                  steps: 0)
  for dir in @["N", "S", "W", "E"]:
    var nic = NewIntCode(prog, compassToInput(dir))
    search.addLast(Search(pos: Point(x: compassXOffset(dir),
                                     y: compassYOffset(dir)),
                          steps: 1,
                          ic: nic))
  var visited = initTable[Point, bool]()
  while len(search) > 0:
    var cur = search.popFirst
    var res = cur.ic.NextOutput()
    if res == 0:
      ship.wall[cur.pos] = true
    elif res == 1:
      for dir in @["N", "S", "W", "E"]:
        var np = Point(x: cur.pos.x + compassXOffset(dir),
                       y: cur.pos.y + compassYOffset(dir))
        if visited.hasKey(np):
          continue
        visited[np] = true
        var input = compassToInput(dir)
        var nic = cur.ic.CloneWithInput(input)
        search.addLast(Search(pos: np,
                          steps: cur.steps + 1,
                          ic: nic))
    elif res == 2:
      var p = new Point
      p.x = cur.pos.x
      p.y = cur.pos.y
      ship.os = p
      var ic = GetIntCodeRef(cur.ic.CloneWithInput(0))
      ship.osic = ic
      ship.steps = cur.steps
  return ship

proc part2(ship: var Ship): int64 =
  var search = initDeque[Search]()
  for dir in @["N", "S", "W", "E"]:
    var nic = ship.osic[].CloneWithInput(compassToInput(dir))
    search.addLast(Search(pos: Point(x: ship.os.x + compassXOffset(dir),
                                     y: ship.os.y + compassYOffset(dir)),
                          steps: 1,
                          ic: nic))
  var visited = initTable[Point, bool]()
  var maxSteps = -2147483648
  while len(search) > 0:
    var cur = search.popFirst
    var res = cur.ic.NextOutput()
    if res == 0:
      ship.wall[cur.pos] = true
    elif res == 1:
      if cur.steps > maxSteps:
         maxSteps = cur.steps
      for dir in @["N", "S", "W", "E"]:
        var np = Point(x: cur.pos.x + compassXOffset(dir),
                       y: cur.pos.y + compassYOffset(dir))
        if visited.hasKey(np):
          continue
        visited[np] = true
        if ship.wall.hasKey(np):
          continue
        var input = compassToInput(dir)
        var nic = cur.ic.CloneWithInput(input)
        search.addLast(Search(pos: np,
                          steps: cur.steps + 1,
                          ic: nic))
  return maxSteps

var ship = part1(prog)
echo "Part 1: ", ship.steps
echo "Part 2: ", part2(ship)
