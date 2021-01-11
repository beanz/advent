import aoclib

type Game = object
    orbits : Table[string, string]
    cache : Table[string, Table[string, int]]

var inp = readInputLines()

proc parse(inp: seq[string]) : Game =
  var g = Game()
  for l in inp:
    var s = l.split(')')
    g.orbits[s[1]] = s[0]
  return g

method parents(this: var Game, obj : string): Table[string, int] {.base.} =
  if this.cache.hasKey(obj):
    return this.cache[obj]
  var p = initTable[string, int]()
  if not this.orbits.hasKey(obj):
    this.cache[obj] = p
    return p

  var parent = this.orbits[obj]
  p[parent] = 0
  for grand, dist in this.parents(parent):
    p[grand] = dist + 1

  this.cache[obj] = p
  return p

proc part1(g: var Game): int64 =
  var s = 0
  for key in g.orbits.keys:
    s += g.parents(key).len
  return s

proc part2(g: var Game): int64 =
  var p1 = g.parents("YOU")
  var p2 = g.parents("SAN")
  var minDist : int64 = 999999999
  for p, d1 in p1:
    if p2.hasKey(p):
      var d = d1 + p2[p]
      if minDist > d:
        minDist = d
  return minDist

var tg1 = parse(@["COM)B","B)C","C)D","D)E","E)F","B)G",
                  "G)H","D)I","E)J","J)K","K)L"])
assert tg1.part1() == 42
var tg2 = parse(@["COM)B","B)C","C)D","D)E","E)F","B)G","G)H",
                  "D)I","E)J","J)K","K)L","K)YOU","I)SAN"])
assert tg2.part2() == 4

var g = parse(inp)

echo "Part 1: ", part1(g)
echo "Part 2: ", part2(g)
