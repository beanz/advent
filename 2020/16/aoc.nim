import aoclib

type Field = tuple
  min1, max1, min2, max2 : int

type Game = object
  fieldSpec: Table[string,Field]
  our: seq[int]
  valid: seq[seq[int]]
  invalidCount: int

proc initGame(inp : seq[string]) : Game =
  var fs = initTable[string, Field]()
  for l in inp[0].split("\n"):
    var ls = l.split(": ")
    var name = ls[0]
    var ints = ls[1].split(" or ").map(r => r.split("-").map(x => parseInt(x)))
    var f : Field = (min1: ints[0][0], max1: ints[0][1],
                  min2: ints[1][0], max2: ints[1][1])
    fs[name] = f
  var our = inp[1].split("\n")[1].split(",").map(x => parseInt(x))
  var valid : seq[seq[int]] = @[]
  valid.add(our)
  var iv = 0
  for l in inp[2].split("\n")[1..^1]:
    var ticket = l.split(",").map(x => parseInt(x))
    var validTicket = true
    for v in ticket:
      var validField = false
      for f in fs.values:
        if (f.min1 <= v and v <= f.max1) or (f.min2 <= v and v <= f.max2):
          validField = true
          break
      if not validField:
        validTicket = false
        iv += v
    if validTicket:
      valid.add(ticket)
  return Game(fieldSpec: fs, our: our, valid: valid, invalidCount: iv)

method part1(s:Game) : int {.base.} =
  return s.invalidCount

method part2(s:Game) : int {.base.} =
  var poss = initTable[string, HashSet[int]]()
  for k in s.fieldSpec.keys:
    poss[k] = initHashSet[int]()
  var target = s.valid.len
  for col in countup(0, s.our.len-1):
    for name, f in s.fieldSpec:
      var valid = 0
      for vt in s.valid:
        var v = vt[col]
        if (f.min1 <= v and v <= f.max1) or (f.min2 <= v and v <= f.max2):
          valid += 1
      if valid == target:
        if debug():
          echo "possible ", name, " at column ", col
        poss[name].incl(col)
  var p : int = 1
  while poss.len > 0:
    var progress = false
    var todel : seq[string] = @[]
    for name, cols in poss:
      if cols.len == 1:
        progress = true
        var col = poss[name].pop
        if debug():
          echo name, " is definitely column ", col
        todel.add(name)
        for name in poss.keys:
          poss[name].excl(col)
        if name.startsWith("departure") or isTest():
          p *= s.our[col]
          if debug():
            echo "product: ", p
    for name in todel:
      poss.del(name)
    if not progress:
      raise newException(ValueError, "solver not making progress")
  return p

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var g = initGame(Chunks(inp))
  let p1 = g.part1()
  let p2 = g.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
