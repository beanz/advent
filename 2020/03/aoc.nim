import aoclib

type
  Trees = object
    tm: IntSet
    width: int
    height: int

proc NewTrees(inp: seq[string]): Trees =
  var m = initIntSet()
  var w = len(inp[0])
  for y, line in inp.pairs:
    for x, ch in line.pairs:
      if ch == '#':
        m.incl(y*w+x)
  return Trees(tm: m, width: w, height: len(inp))

proc isTree(s: Trees, x:int, y:int): bool =
  return s.tm.contains(y*s.width+(x mod s.width))

proc traverse(s: Trees, sx:int, sy:int): int =
  var c = 0
  var x = sx
  for y in countup(sy, s.height, sy):
    if s.isTree(x, y):
      c += 1
    x += sx
  return c

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var trees = NewTrees(Lines(inp))
  let p1 = trees.traverse(3,1)
  const slopes = @[[1,1],[3,1],[5,1],[7,1],[1,2]]
  var p2:int64 = slopes.map(x => trees.traverse(x[0], x[1])).foldl(a * b)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
