import aoclib

type Hex = object
  q : int16
  r : int16

proc initHex(moves : string) : Hex =
  var q : int16 = 0
  var r : int16 = 0
  var i = 0
  while i < moves.len:
    case moves[i]
    of 'e':
      q += 1
      i += 1
    of 'w':
      q -= 1
      i += 1
    of 's':
      case moves[i+1]
      of 'e':
        r -= 1
        i += 2
      of 'w':
        q -= 1
        r -= 1
        i += 2
      else:
        raise newException(ValueError,
                           "invalid moves: " & $moves & " at index " & $i)
    of 'n':
      case moves[i+1]
      of 'e':
        q += 1
        r += 1
        i += 2
      of 'w':
        r += 1
        i += 2
      else:
        raise newException(ValueError,
                           "invalid moves: " & $moves & " at index " & $i)
    else:
      raise newException(ValueError,
                         "invalid moves: " & $moves & " at index " & $i)
  return Hex(q: q, r: r)

method str(s: Hex) : string {.base.} =
  return "H<" & $(s.q) & "," & $(s.r) & ">"

proc `==`(a: Hex, b: HeX) : bool =
  return a.q == b.q and a.r == b.r

proc hash(a: Hex) : Hash =
  return ((a.q.int32 shl 16) + a.r).hash

method neighbours(s: Hex) : seq[Hex] {.base.} =
  return @[
           [1'i16, 0'i16],
           [0'i16, -1'i16],
           [-1'i16, -1'i16],
           [-1'i16, 0'i16],
           [0'i16, 1'i16],
           [1'i16, 1'i16]
          ].map(x => Hex(q: s.q+x[0], r: s.r+x[1]))

type Game = object
  init : HashSet[Hex]


proc initGame(inp : seq[string]) : Game =
  var init = initHashSet[Hex]()
  for l in inp:
    var h = initHex(l)
    if init.contains(h):
      init.excl h
    else:
      init.incl h
  return Game(init: init)

method part1(s: Game) : int {.base.} =
  return s.init.len

method part2(s: Game) : int {.base.} =
  var cur = deepCopy(s.init)
  var toCheck = deepCopy(cur)
  for h in cur:
    for nh in h.neighbours:
      toCheck.incl nh
  for day in countup(1,100):
    var nextToCheck = initHashSet[Hex]()
    var new = initHashSet[Hex]()
    for h in toCheck:
      var nbs = h.neighbours
      var c = 0
      for nb in nbs:
        if cur.contains(nb):
          c += 1
      if (cur.contains(h) and not (c == 0 or c > 2)) or
         (not cur.contains(h) and c == 2):
        nextToCheck.incl h
        for nb in nbs:
          nextToCheck.incl(nb)
        new.incl(h)
    cur = new
    toCheck = nextToCheck
    if debug():
      echo "Day ", day, ": ", cur.len
  return cur.len

var inp = readInputLines()
var g = initGame(inp)
echo "Part 1: ", g.part1
echo "Part 2: ", g.part2
