import aoclib

type LastSeenArray = array[30000000, int]
var seen : LastSeenArray

type Game = object
  init : seq[int]

proc initGame(inp : seq[int]) : Game =
  return Game(init: inp)

method calc(s: Game, turns : int) : int {.base.} =
  for i in low(seen)..high(seen):
    seen[i] = 0
  var n = 0
  var p = 0
  for i in countup(0, s.init.len-1):
    n = s.init[i]
    if i > 0:
      seen[p] = i+1
    p = n
  for t in countup(s.init.len+1, turns):
    if seen[p] > 0:
      n = t-seen[p]
    else:
      n = 0
    seen[p] = t
    p = n
  return n

method part1(s:Game) : int {.base.} =
  return s.calc(2020)

method part2(s:Game) : int {.base.} =
  return s.calc(30000000)

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var g = initGame(Ints(inp))
  let p1 = g.part1()
  let p2 = g.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
