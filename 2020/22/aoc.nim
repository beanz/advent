import aoclib

type Game = object
    decks : array[2, seq[int]]

proc initGame(inp : seq[string]) : Game =
  var s = Game()
  for i in countup(0,1):
    s.decks[i] = inp[i].split("\n")[1..^1].map(x => parseInt(x))
  return s

method score(s: Game, d : Deque[int]) : int {.base.} =
  var sc = 0
  for i, c in d.pairs:
    sc += (d.len - i) * c
  return sc

type Result = tuple
  player: int
  deck: Deque[int]

method combat(s :Game, d : var array[2, Deque[int]], part2: bool) : Result {.base.} =
  var round = 1
  var seen = initIntSet()
  while d[0].len > 0 and d[1].len > 0:
    if debug():
      echo round, ": d1=", d[0], " d1=", d[1]
    var k = s.score(d[0]) * s.score(d[1])
    if seen.contains(k):
      return (player: 0, deck: d[0])
    seen.incl(k)
    var c : array[2, int] = [d[0].popFirst, d[1].popFirst]
    var winner : int
    if part2 and d[0].len >= c[0] and d[1].len >= c[1]:
      if debug(): echo "starting subgame"
      var ds : array[2, Deque[int]]
      for p in countup(0, 1):
        for i in countup(0, c[p]-1):
          ds[p].addLast(d[p][i])
      var res = s.combat(ds, true)
      winner = res.player
    else:
      winner = if c[0] > c[1]: 0 else: 1
    if debug():
      echo round, ": player ", winner+1
    d[winner].addLast(c[winner])
    d[winner].addLast(c[1-winner])
    round += 1
  var res : Result = if d[0].len > 0: (player: 0, deck: d[0]) else: (player: 1, deck: d[1])
  return res

method play(s: Game, part2: bool) : int {.base.} =
  var ds : array[2, Deque[int]] = [s.decks[0].toDeque, s.decks[1].toDeque]
  var res = s.combat(ds, part2)
  return s.score(res.deck)

method part1(s: Game) : int {.base.} =
  return s.play(false)

method part2(s: Game) : int {.base.} =
  return s.play(true)

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var g = initGame(Chunks(inp))
  let p1 = g.part1()
  let p2 = g.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
