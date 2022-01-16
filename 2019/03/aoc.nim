import aoclib

proc path(s: string): Table[(int,int), int] =
  var p = initTable[(int,int), int]()
  var x = 0
  var y = 0
  var steps = 0
  for m in s.split(','):
    var d = m[0]
    var s = m[1 .. m.len-1].parseInt()
    for c in countup(1, s):
      case d
      of 'U':
        y -= 1
      of 'D':
        y += 1
      of 'L':
        x -= 1
      else:
        x += 1
      steps += 1
      p[(x,y)] = steps
  return p

proc calc(inp: seq[string]): (int,int) =
  var p1 = path(inp[0])
  var p2 = path(inp[1])
  var dist = 2147483647
  var steps = 2147483647
  for p, s1 in p1:
    if p2.hasKey(p):
      var s = s1 + p2[p]
      if s < steps:
        steps = s
      var d = abs(p[0]) + abs(p[1])
      if d < dist:
        dist = d

  return (dist,steps)

assert calc(@["R8,U5,L5,D3", "U7,R6,D4,L4"]) == (6, 30)
assert calc(@["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
              "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]) == (135, 410)
assert calc(@["R75,D30,R83,U83,L12,D49,R71,U7,L72",
              "U62,R66,U55,R34,D71,R55,D58,R83"]) == (159, 610)

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  let (dist, steps) = calc(Lines(inp))
  if not bench:
    echo "Part 1: ", dist
    echo "Part 2: ", steps
)
