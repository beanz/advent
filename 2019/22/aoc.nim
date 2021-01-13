import "aoclib"

type ShuffleKind = enum Deal, Cut, DealInc
type Params = tuple
  a : int64
  b : int64

type Shuffle = object
  kind : ShuffleKind
  num : int64

proc initShuffle(s : string) : Shuffle =
  if s.startsWith("deal into"):
    return Shuffle(kind: ShuffleKind.Deal, num: 0)
  var num : int64 = parseBiggestInt(s.split(" ")[^1])
  var k = if s.startsWith("cut"): ShuffleKind.Cut else: ShuffleKind.DealInc
  return Shuffle(kind: k, num: num)

method params(s: Shuffle, a : int64, b : int64,
              numCards : int64) : Params {.base.} =
  var na : int64
  var nb : int64
  case s.kind
  of ShuffleKind.Deal:
    na = -a
    nb = -b - 1
  of ShuffleKind.Cut:
    na = a
    nb = b - s.num
  else:
    na = a * s.num
    nb = b * s.num
  return (a: (na+numCards) mod numCards, b: (nb+numCards) mod numCards)

type Game = object
  shuffles : seq[Shuffle]
  cards : int64

proc initGame(inp : seq[string], cards : int64) : Game =
  var s : seq[Shuffle] = @[]
  for l in inp:
    s.add(initShuffle(l))
  return Game(shuffles: s, cards: cards)

method params(g: Game) : Params {.base.} =
  var a : int64 = 1
  var b : int64 = 0
  for s in g.shuffles:
    let p = s.params(a, b, g.cards)
    a = p.a
    b = p.b
  return (a: a, b: b)

method forward(g: Game, card : int64) : int64 {.base.} =
  var p = g.params()
  return (((p.a * card) + p.b) mod g.cards)

var inp = readInputLines()
var g = initGame(inp, 10007)

echo "Part 1: ", g.forward(2019)
echo "Part 2: ", "needs bigint"

