import aoclib

type
  Seat = enum None, Empty, Occupied
  NeighbourCache = seq[seq[int]]
  Seats = object
    cur : seq[Seat]
    new : seq[Seat]
    w : int
    h : int

proc NewSeats(inp : seq[string]): Seats =
  let h = inp.len
  let w = inp[0].len
  var cur = inp.map(l => l.map(ch => (if ch == 'L': Seat.Empty else: Seat.None)  )).foldl(a.concat(b)).toSeq
  return Seats(cur: cur, new: deepCopy(cur), w: w, h: h)

proc `$`(s: Seats): string =
  var r = ""
  for y in countup(0, s.h-1):
    for x in countup(0, s.w-1):
      case s.cur[x+s.w*y]
      of Seat.Occupied:
        r &= "#"
      of Seat.Empty:
        r &= "L"
      else:
        r &= "."
    r &= "\n"
  return r

method seat(s: Seats, x : int, y:int) : Seat {.base.} =
  return s.cur[x + s.w*y]

method seat(s: Seats, i:int) : Seat {.base.} =
  return s.cur[i]

method neighbours(s: Seats, x : int, y:int, sight: bool) : seq[int] {.base.} =
  var nc : seq[int] = @[]
  for ox in countup(-1, 1):
    for oy in countup(-1, 1):
      if ox == 0 and oy == 0:
        continue
      var nx = x + ox
      var ny = y + oy
      var seat = Seat.None
      while 0 <= nx and nx < s.w and 0 <= ny and ny < s.h:
        seat = s.seat(nx, ny)
        if seat != Seat.None or not sight:
          break
        nx += ox
        ny += oy
      if seat == Seat.Empty:
        nc.add(nx + s.w * ny)
  return nc

method initNeighbourCache(s: Seats, sight : bool) : NeighbourCache {.base.} =
  var nc : NeighbourCache = @[]
  for i in countup(0, s.w*s.h-1):
    if s.cur[i] == Seat.None:
      nc.add(@[])
      continue
    let x = i mod s.w
    let y = i div s.w
    let n = s.neighbours(x,y,sight)
    nc.add(n)
  return nc

method occupiedCount(s: Seats, i : int, cache: NeighbourCache) : int {.base.} =
  var c = 0
  for ni in cache[i]:
    if s.seat(ni) == Seat.Occupied:
      c += 1
  return c

method run(s: var Seats, group: int) : int {.base.} =
  var oc = 0
  var ncache = s.initNeighbourCache(group == 5)
  var changes = 1
  var next = deepCopy(s.cur)
  if debug():
    echo s
  while changes > 0:
    changes = 0
    oc = 0
    for i in countup(0, s.w*s.h-1):
      let cur = s.seat(i)
      if cur == Seat.None:
        continue
      let nc = s.occupiedCount(i, ncache)
      var new = cur
      if cur == Seat.Empty and nc == 0:
        changes += 1
        new = Seat.Occupied
      elif cur == Seat.Occupied and nc >= group:
        changes += 1
        new = Seat.Empty
      next[i] = new
      if new == Seat.Occupied:
        oc += 1
    swap(s.cur, next)
    if debug():
      echo "changes=", changes, " oc=", oc
      echo s
  return oc

method part1(s: var Seats) : int {.base.} =
  return s.run(4)

method part2(s: var Seats) : int {.base.} =
  return s.run(5)

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var s = NewSeats(Lines(inp))
  let p1 = s.part1()
  s = NewSeats(Lines(inp))
  let p2 = s.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
