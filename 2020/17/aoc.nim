import aoclib

let MAX : int = 24
let OFF : int = 12

type XY = tuple
  x: int
  y: int

type Game = object
  w : int
  w2 : int
  init : seq[XY]

proc initGame(inp : seq[string]) : Game =
  var w = inp.len
  var i : seq[XY] = @[]
  for y in countup(0, inp.len-1):
    var l = inp[y]
    for x in countup(0, l.len-1):
      if l[x] == '#':
        var xy :XY = (x: x, y: y)
        i.add(xy)
  return Game(w: w, w2: (w div 2), init: i)

method index(s: Game, x: int, y: int, z :int, q:int) : int {.base.} =
  return x+OFF + MAX*(y+OFF + MAX*(z+OFF + MAX*(q+OFF)))

method calc(s: Game, part2: bool) : int {.base.} =
  var cur = initIntSet()
  for xy in s.init:
    cur.incl(s.index(xy.x,xy.y,0,0))
  var next = initIntSet()
  var r = 0
  var qo = if part2: 1 else: 0
  for iter in countup(1, 6):
    r = 0
    var qs = if part2: 1+iter else: 0
    var xys = 1+s.w2+iter
    for q in countup(-qs, qs):
      for z in countup(-(1+iter), 1+iter):
        for y in countup(-xys, 1+xys):
          for x in countup(-xys, 1+xys):
            var nc = 0
            for oq in countup(-qo, qo):
              for oz in countup(-1, 1):
                for oy in countup(-1, 1):
                  for ox in countup(-1, 1):
                    if oq == 0 and oz == 0 and oy == 0 and ox == 0:
                      continue
                    if cur.contains(s.index(x+ox,y+oy,z+oz,q+oq)):
                      nc += 1
            var i = s.index(x, y, z, q)
            var st = cur.contains(i)
            if (st and nc == 2) or nc == 3:
              next.incl(i)
              r += 1
    swap(cur, next)
    next.clear()
    if debug():
      echo "Live: ", r
  return r

method part1(s:Game) : int {.base.} =
  return s.calc(false)

method part2(s:Game) : int {.base.} =
  return s.calc(true)

var inp = readInputLines()
var g = initGame(inp)
echo "Part 1: ", g.part1()
echo "Part 2: ", g.part2()
