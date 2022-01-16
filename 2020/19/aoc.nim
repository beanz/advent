import aoclib, re

type Rule = tuple
  ch : string
  options : seq[seq[int]]

type Game = object
  rules : Table[int, Rule]
  values : seq[string]

proc initGame(inp : seq[string]) : Game =
  var r = initTable[int,Rule]()
  var v = inp[1].split("\n")
  var emptyOpt : seq[seq[int]] = @[]
  for rl in inp[0].split("\n"):
    var ss = rl.split(": ")
    var n = parseInt(ss[0])
    var rule : Rule = (ch: "", options: emptyOpt)
    if ss[1][0] == '"':
      rule.ch &= ss[1][1]
    else:
      rule.options = ss[1].split(" | ")
        .map(x => x.split(" ").map(rn => parseInt(rn)))
    r[n] = rule

  return Game(rules: r, values: v)

method regexp(g: Game, num : int) : string {.base.} =
  var rule = g.rules[num]
  if rule.ch != "":
    return rule.ch
  var res = rule.options.map(o => o.map(rn => g.regexp(rn)).join).join("|")
  if debug():
    echo "re[", num, "] = ", res
  return "(?:" & res & ")"

method part1(g: Game) : int {.base.} =
  var re = re("^" & g.regexp(0) & "$")
  var c = 0
  for v in g.values:
    if v.match(re):
      c += 1
  return c

method part2(g: var Game) : int {.base.} =
  var re31 = g.regexp(31)
  var re42 = g.regexp(42)
  g.rules[8].ch = re42 & "+"
  var ns : seq[string] = @[]
  for n in countup(1, 5):
    ns.add(re42 & "{" & $(n) & "}" & re31 & "{" & $(n) & "}")
  g.rules[11].ch = "(?:" & ns.join("|") & ")"
  return g.part1

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var g = initGame(Chunks(inp))
  let p1 = g.part1()
  let p2 = g.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
