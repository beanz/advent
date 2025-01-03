import aoclib

proc part1(inp: string): int64 =
  var res = 0
  var min = 4294967295
  for i in countup(0, (len(inp) div 150)-1):
    var c = [0,0,0]
    for j in countup(0, 149):
      c[int(inp[i*150+j])-48] += 1
    if c[0] < min:
      min = c[0]
      res = c[1] * c[2]
  return res

proc part2(inp: string): string =
  var res = ""
  for y in countup(0,5):
    for x in countup(0,24):
      var i = y*25+x
      while i < len(inp):
        if inp[i] == '0':
          res.add(' ')
          break
        if inp[i] == '1':
          res.add('#')
          break
        i += 150
    res.add('\n')
  return res

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var l = inp.strip(chars = {'\n'})
  let p1 = part1(l)
  let p2 = part2(l)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2:\n", p2
)
