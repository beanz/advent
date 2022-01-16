import aoclib

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var lists = Lists(inp)
  var p1:int64 = 0
  for e in lists:
    var cc = e[4].count(e[2][0])
    if parseInt(e[0]) <= cc and cc <= parseInt(e[1]):
      p1 += 1

  var p2:int64 = 0
  for e in lists:
    var c1 = e[4][parseInt(e[0])-1]
    var c2 = e[4][parseInt(e[1])-1]
    if c1 != c2 and (c1 == e[2][0] or c2 == e[2][0]):
      p2 += 1
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
