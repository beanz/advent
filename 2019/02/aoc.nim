import aoclib

var prog: seq[int64] = readInputInt64s()

proc part1(prog_c: seq[int64]): int64 =
  var prog: seq[int64]
  deepCopy(prog, prog_c)
  var ip = 0
  var l = len(prog)
  while ip < l:
    var op = prog[ip]
    ip += 1
    case op
    of 1:
      if ip+2 >= l:
        return -1
      var i1 = prog[ip]
      ip += 1
      var i2 = prog[ip]
      ip += 1
      var o = prog[ip]
      ip += 1
      prog[o] = prog[i1] + prog[i2]
    of 2:
      if ip+2 >= l:
        return -2
      var i1 = prog[ip]
      ip += 1
      var i2 = prog[ip]
      ip += 1
      var o = prog[ip]
      ip += 1
      prog[o] = prog[i1] * prog[i2]
    of 99:
      return prog[0]
    else:
      return -3
  return -4

proc part2(prog_c: seq[int64]): int64 =
  var prog: seq[int64]
  deepCopy(prog, prog_c)
  for input in countup(0, 9999):
    prog[1] = (input / 100).int64
    prog[2] = input mod 100
    var res = part1(prog)
    if res == 19690720:
      return input
  result = -1

assert part1(@[int64(1),0,0,0,99]) == 2
assert part1(@[int64(1),1,1,4,99,5,6,0,99]) == 30

prog[1] = 12
prog[2] = 2
echo "Part 1: ", part1(prog)

echo "Part 2: ", part2(prog)
