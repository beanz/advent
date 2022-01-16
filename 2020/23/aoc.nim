import aoclib

type Cup = tuple
  cw : int
  ccw : int

type Game = object
    cups : seq[Cup]
    cur : int
    mx : int

proc initGame(inp : string, mx : int) : Game =
  var cups = newSeqOfCap[Cup](mx+1)
  for i in countup(0,9):
    cups.add((cw: i, ccw: i))
  var ss = inp.map(x => ord(x)-ord('0'))
  for i in (1..7):
    var c = ss[i]
    var p = ss[i-1]
    var n = ss[i+1]
    cups[p].cw = c
    cups[n].ccw = c
    cups[c].ccw = p
    cups[c].cw = n
  cups[ss[8]].cw = ss[0]
  cups[ss[0]].ccw = ss[8]
  if mx > 9:
    cups.add((cw: 11, ccw: ss[8]))
    for i in countup(11,mx-1):
      cups.add((cw: i+1, ccw: i-1))
    cups.add((cw: ss[0], ccw: mx-1))
    cups[ss[0]].ccw = mx
    cups[ss[8]].cw = 10
  return Game(cups: cups, cur: ss[0], mx: mx)

method str(s: Game) : string {.base.} =
  var res = $(s.cur)
  var c = s.cups[s.cur].cw
  while c != s.cur:
    res &= $(c)
    c = s.cups[c].cw
  return res

method rstr(s: Game) : string {.base.} =
  var res = $(s.cur)
  var c = s.cups[s.cur].ccw
  while c != s.cur:
    res &= $(c)
    c = s.cups[c].ccw
  return res

method p1str(s: Game) : string {.base.} =
  var res = ""
  var c = s.cups[1].cw
  while c != 1:
    res &= $(c)
    c = s.cups[c].cw
  return res

method pick(s: var Game, cur : int) : int {.base.} =
  var p1 = s.cups[cur].cw
  var p2 = s.cups[p1].cw
  var p3 = s.cups[p2].cw
  var n = s.cups[p3].cw
  # fix self
  s.cups[cur].cw = n
  s.cups[n].ccw = cur
  # fix picked ring
  s.cups[p1].ccw = p3
  s.cups[p3].cw = p1
  return p1

method insertAfter(s: var Game, cur : int, new : int) : void {.base.} =
  var after = s.cups[cur].cw
  var last = s.cups[new].ccw
  s.cups[cur].cw = new
  s.cups[new].ccw = cur
  s.cups[last].cw = after
  s.cups[after].ccw = last

method calc(s: var Game, rounds : int) : void {.base.} =
  var cur = s.cur
  for round in countup(1,rounds):
    var p1 = s.pick(cur)
    var p2 = s.cups[p1].cw
    var p3 = s.cups[p2].cw
    var dst = cur
    while true:
      dst -= 1
      if dst == 0:
        dst = s.mx
      if dst != p1 and dst != p2 and dst != p3:
        break
    s.insertAfter(dst, p1)
    cur = s.cups[cur].cw

method part1(s: var Game, rounds : int) : string {.base.} =
  s.calc(rounds)
  return s.p1str

method part2(s: var Game, rounds : int) : int {.base.} =
  s.calc(rounds)
  return s.cups[1].cw * s.cups[s.cups[1].cw].cw

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var l = inp.strip(chars = {'\n'})
  var g = initGame(l, 9)
  let p1 = g.part1(100)
  g = initGame(l, 1000000)
  let p2 = g.part2(10000000)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
