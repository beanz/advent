import aoclib

var inp = readInputLines()
var bags = initTable[string, seq[tuple[num: int, bag:string]]]()
var rbags = initTable[string, seq[string]]()

for l in inp:
  let ls =l.split(" bags contain ")
  if ls[1].startsWith("no other"):
    continue
  #bags[ls[0]] : seq[tuple[num: int, bag: string]] = @[]
  for spec in ls[1].split(", "):
    var ss = spec.split(" ")
    var bag = ss[1] & " " & ss[2]
    if not bags.contains(ls[0]):
      bags[ls[0]] = @[]
    bags[ls[0]].add((num: parseInt(ss[0]), bag: bag))
    if not rbags.contains(bag):
      rbags[bag] = @[]
    rbags[bag].add(ls[0])

var s = initTable[string,bool]()
proc part1(g : Table[string, seq[string]], bag:string): void =
  if not g.contains(bag):
    return
  for outer in g[bag]:
    s[outer] = true
    part1(g, outer)
  return

part1(rbags, "shiny gold")
echo "Part 1: ", s.len

proc part2(g : Table[string, seq[tuple[num: int, bag:string]]],
           bag:string) : int =
  if not g.contains(bag):
    return 1
  var c = 1
  for inner in g[bag]:
    c += inner[0] * part2(g, inner[1])
  return c

echo "Part 2: ", part2(bags, "shiny gold")-1
