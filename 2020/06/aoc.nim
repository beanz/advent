import aoclib

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var chunks = Chunks(inp).map(x => x.split("\n").map(y => y.map(ch => ch).toHashSet))
  var unions = chunks.map(x => x.foldl(a+b))
  let p1 = unions.map(len).foldl(a + b)
  var intersects = chunks.map(x => x.foldl(a * b))
  let p2 = intersects.map(len).foldl(a + b)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
