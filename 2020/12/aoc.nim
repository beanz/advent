import aoclib

type Move = tuple
  ch: char
  n: int

type Nav = object
    moves : seq[Move]

proc initNav(inp: seq[string]) : Nav =
  var moves : seq[Move] = @[]
  for l in inp:
    var move : Move = (ch: l[0], n: parseInt(l[1..^1]))
    moves.add(move)
  return Nav(moves: moves)

method part1(s: Nav) : int {.base.} =
  var dir = initPoint('E')
  var pos = initPoint(0,0)
  for m in s.moves:
    case m.ch
    of 'F':
      pos.move(dir, m.n)
    of 'N':
      pos.moveY(-1 * m.n)
    of 'S':
      pos.moveY(m.n)
    of 'E':
      pos.moveX(m.n)
    of 'W':
      pos.moveX(-1 * m.n)
    of 'L':
      for _ in countup(1, m.n div 90):
        dir.ccw()
    of 'R':
      for _ in countup(1, m.n div 90):
        dir.cw()
    else:
      raise newException(ValueError, "invalid movement type: " & m.ch)
  return pos.manhattan

method part2(s: Nav) : int {.base.} =
  var pos = initPoint(0, 0)
  var wp = initPoint(10, -1)
  for m in s.moves:
    case m.ch
    of 'F':
      pos.move(wp, m.n)
    of 'N':
      wp.moveY(-1 * m.n)
    of 'S':
      wp.moveY(m.n)
    of 'E':
      wp.moveX(m.n)
    of 'W':
      wp.moveX(-1 * m.n)
    of 'L':
      for _ in countup(1, m.n div 90):
        wp.ccw()
    of 'R':
      for _ in countup(1, m.n div 90):
        wp.cw()
    else:
      raise newException(ValueError, "invalid movement type: " & m.ch)
  return pos.manhattan

var inp = readInputLines()
var nav = initNav(inp)
echo "Part 1: ", nav.part1()
echo "Part 2: ", nav.part2()
