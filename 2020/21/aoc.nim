import aoclib

type Game = object
    allergens : Table[string,IntSet]
    ingredients : Table[string,IntSet]
    possible : Table[string, HashSet[string]]

proc initGame(inp : seq[string]) : Game =
  var s = Game(allergens: initTable[string,IntSet](),
               ingredients: initTable[string,IntSet](),
               possible: initTable[string, HashSet[string]]())
  for i, l in inp:
    var ls = l.split(" (contains ")
    var ings = ls[0].split(" ")
    var alls = ls[1][0..^2].split(", ")
    for a in alls:
      if not s.allergens.contains(a):
        s.allergens[a] = initIntSet()
      s.allergens[a].incl(i)
    for ing in ings:
      if not s.ingredients.contains(ing):
        s.ingredients[ing] = initIntSet()
      s.ingredients[ing].incl(i)
  for ing in s.ingredients.keys:
    for all, lineNums in s.allergens:
      var maybeThisAllergen = true
      for n in lineNums:
        if not s.ingredients[ing].contains(n):
          maybeThisAllergen = false
      if maybeThisAllergen:
        if debug():
          echo ing, " could be ", all
        if not s.possible.contains(ing):
          s.possible[ing] = initHashSet[string]()
        s.possible[ing].incl(all)
  return s

method part1(s: var Game) : int {.base.} =
  var c = 0
  for ing, lineNums in s.ingredients:
    if not s.possible.contains(ing):
      c += lineNums.len
  return c

type Solution = tuple
  all: string
  ing: string

method part2(s: var Game) : string {.base.} =
  var res : seq[Solution] = @[]
  while s.possible.len > 0:
    var progress = false
    var todel : seq[string] = @[]
    for ing, alls in s.possible:
      if alls.len != 1:
        continue
      progress = true
      var all = s.possible[ing].pop()
      if debug():
        echo ing, " is ", all
      var sol : Solution = (all: all, ing: ing)
      res.add(sol)
      todel.add(ing)
      for x in s.possible.keys:
        s.possible[x].excl(all)
    for ing in todel:
      s.possible.del(ing)
    if not progress:
      raise newException(ValueError, "solver not making progress")
  res.sort((a, b) => cmp(a.all, b.all))
  return res.map(x => x.ing).join(",")

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var g = initGame(Lines(inp))
  let p1 = g.part1()
  let p2 = g.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
