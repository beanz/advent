import aoclib, intcode

proc tryPhase(prog: seq[int64], phase: seq[int64]): int64 =
  var u: seq[IntCode]
  for i in countup(0, len(phase)-1):
    let g = NewIntCode(prog, phase[i])
    u.add(g)
  var done : int64 = 0
  var last : int64 = 0
  var output : int64 = 0
  var first = true
  while done < len(phase):
    done = 0
    for i in countup(0, len(phase)-1):
      if u[i].Done():
        done += 1
      else:
        if first:
          u[i].AddInput(0)
        if not first:
          u[i].AddInput(output)
        first = false
        var rc = u[i].Run()
        if rc == 0:
          output = u[i].NextOutput()
          last = output
        else:
          done += 1
  return last

proc run(prog: seq[int64], minPhase: int64): int64 =
  var perm = @[minPhase, minPhase+1, minPhase+2, minPhase+3, minPhase+4]
  var max = -2147483648'i64
  while true:
    var thrust = tryPhase(prog, perm)
    if max < thrust:
      max = thrust
    if not perm.nextPermutation():
      break
  return max

proc part1(prog: seq[int64]): int64 =
  return run(prog, 0)

proc part2(prog: seq[int64]): int64 =
  return run(prog, 5)

assert try_phase(@[int64(3),15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0],
                 @[int64(4),3,2,1,0]) == 43210
assert part1(@[int64(3),15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]) == 43210
assert part1(@[int64(3),23,3,24,1002,24,10,24,1002,23,-1,23,
           101,5,23,23,1,24,23,23,4,23,99,0,0]) == 54321
assert part1(@[int64(3),31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
           1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]) == 65210
assert part2(@[int64(3),26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
           27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]) == 139629729
assert part2(@[int64(3),52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,
               1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,
               55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,
               99,0,0,0,0,10]) == 18216

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var prog = inp.strip(chars = {'\n'}).split(",").map(parseBiggestInt).mapIt(it.int64)
  let p1 = part1(prog)
  let p2 = part2(prog)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
