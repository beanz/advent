import aoclib, intcode, point

type Scaffold = object
    m : Table[Point, bool]
    bb : BoundingBox
    pos : Point
    bot : Point
    dir : Point

proc NewScaffold() : Scaffold =
  return Scaffold(m: initTable[Point,bool](),
                  bb: NewBoundingBox(),
                  pos: Point(x: 0, y: 0),
                  bot: Point(x: -1, y: -1),
                  dir: Point(x: 0, y: -1))

method isPipe(this: Scaffold, p : Point): bool {.base.} =
  return this.m.hasKey(p) and this.m[p]

method String(this: Scaffold): string {.base.} =
  var s = newString((1+this.bb.maxi.x-this.bb.mini.x)*
                    (1+this.bb.maxi.y-this.bb.mini.y))
  for y in countup(this.bb.mini.y, this.bb.maxi.y):
    for x in countup(this.bb.mini.x, this.bb.maxi.x):
      if x == this.bot.x and y == this.bot.y:
        s.add('^')
      elif this.isPipe(Point(x: x, y: y)):
        s.add('#')
      else:
        s.add('.')
    s.add('\n')
  return s

method alignmentSum(this: Scaffold): int64 {.base.} =
  var s : int64 = 0
  for y in countup(this.bb.mini.y, this.bb.maxi.y):
    for x in countup(this.bb.mini.x, this.bb.maxi.x):
      if this.isPipe(Point(x: x, y: y)) and
         this.isPipe(Point(x: x-1, y: y)) and
         this.isPipe(Point(x: x, y: y-1)) and
         this.isPipe(Point(x: x+1, y: y)) and
         this.isPipe(Point(x: x, y: y+1)):
        s += x * y
  return s

proc part1(prog: seq[int64]): Scaffold =
  var scaff = NewScaffold()
  var ic = NewIntCode(prog)
  var output = ic.RunToHalt()
  for ascii in output:
    case ascii:
    of 10:
      scaff.pos.x = 0
      scaff.pos.y += 1
    of 35:
      scaff.m[scaff.pos] = true
      scaff.pos.x += 1
    of 94:
      scaff.m[scaff.pos] = true
      scaff.bot = Point(x: scaff.pos.x, y: scaff.pos.y)
      scaff.pos.x += 1
    else:
      scaff.pos.x += 1
    scaff.bb.Add(scaff.pos)
  #echo scaff.String()
  return scaff

proc nextFunc(path : string, offset :int64, ch : char): string =
  var shortest = high(int64)
  var fun : string
  for i in countup(1, 22):
    var sub = path[offset .. offset+i]
    var t = replace(path, sub, $ch)
    if shortest > len(t):
      shortest = len(t)
      fun = sub
  fun.removeSuffix({',','R','L'})
  return fun

proc part2(prog: var seq[int64], scaff: Scaffold) : int64 =
  var pos = scaff.bot
  var dir = scaff.dir
  var path : seq[int64]
  while true:
    #echo scaff.String()
    var np = pos.pointIn(dir)
    #echo "trying forwards (", dir, "): ", np
    if scaff.isPipe(np):
      #echo "forward!"
      pos = np
      if len(path) > 0 and path[high(path)] > 0:
        path[high(path)] += 1
      else:
        path.add(1)
    else:
      let left = dir.pointCcw()
      let np = pos.pointIn(left)
      #echo "trying left (", left, "): ", np
      if scaff.isPipe(np):
        #echo "left!"
        dir = left
        path.add(-1) # -1 == LEFT
      else:
        let right = dir.pointCw()
        let np = pos.pointIn(right)
        #echo "trying right(", right, "): ", np
        if scaff.isPipe(np):
          #echo "right!"
          dir = right
          path.add(-2) # -2 == RIGHT
        else:
          #echo "deadend ", pos
          break

  var pathStr = ""
  var first = true
  for m in path:
    if not first:
      pathStr.add(',')
    first = false
    if m > 0:
      pathStr.add($m)
    elif m == -1:
      pathStr.add('L')
    elif m == -2:
      pathStr.add('R')
  #echo pathStr
  var fnA = nextFunc(pathStr, 0, 'A')
  pathStr = replace(pathStr, fnA, "A")
  var offset : int64 = 0
  while pathStr[offset] == 'A' or pathStr[offset] == ',':
    offset += 1

  var fnB = nextFunc(pathStr, offset, 'B')
  pathStr = replace(pathStr, fnB, "B")
  while pathStr[offset] == 'A' or
        pathStr[offset] == 'B' or
        pathStr[offset] == ',':
    offset += 1

  var fnC = nextFunc(pathStr, offset, 'C')
  pathStr = replace(pathStr, fnC, "C")

  var fnM = pathStr

  var full : string = join([fnM, fnA, fnB, fnC, "n\n"], "\n")
  #echo full
  prog[0] = 2
  var ic = NewIntCode(prog)
  for ch in full:
    ic.AddInput(int64(ord(ch)))
  var output = ic.RunToHalt()
  return output.peekLast

var prog = readInputInt64s()
var scaff = part1(prog)
echo "Part 1: ", scaff.alignmentSum()
echo "Part 2: ", part2(prog, scaff)
