import aoclib

let
  X = 0
  Y = 1
  Z = 2
  VX = 3
  VY = 4
  VZ = 5

type Moon = array[6, int64]

proc pp_moon(m : Moon): string =
  return "pos=<x=$#, y=$#, z=$#>, vel=<x=$#, y=$#, z=$#>" % map(m, proc (x: int64): string = $x)

proc energy(m : Moon): int64 =
  let e = (abs(m[X]) +
           abs(m[Y]) +
           abs(m[Z])) * (abs(m[VX]) +
                         abs(m[VY]) +
                         abs(m[VZ]))
  return e

proc pp_moons(moons : seq[Moon]): string =
  var s = ""
  for m in moons:
    s &= pp_moon(m) & "\n"
  return s

proc axis_state(moons : seq[Moon], axis : int): string =
  var s = newStringOfCap(30)
  for m in moons:
    s &= $m[axis] & "!" & $m[VX+axis] & "\n"
  return s

proc run_step(moons : var seq[Moon], axis : int): void =
  for i in 0..len(moons)-1:
    for j in i..len(moons)-1:
      if moons[i][axis] > moons[j][axis]:
        moons[i][VX+axis] -= 1
        moons[j][VX+axis] += 1
      elif moons[i][axis] < moons[j][axis]:
        moons[i][VX+axis] += 1
        moons[j][VX+axis] -= 1
  for i in 0..len(moons)-1:
    moons[i][axis] += moons[i][VX+axis]

proc part1(c_moons: seq[Moon], steps : int64): int64 =
  var moons = c_moons
  for step in 1..steps:
    for axis in { X, Y, Z }:
      run_step(moons, axis)
  var s : int64 = 0
  for m in moons:
    s += energy(m)
  return s

proc part2(c_moons: seq[Moon]): int64 =
  var moons = c_moons
  #echo "After 0 steps:\n", pp_moons(moons), "\n"
  var cycle = [int64(-1), -1, -1]
  var initial : seq[string]
  for axis in { X, Y, Z }:
    initial.add(axis_state(moons, axis))
    var steps : int64 = 0
    while cycle[axis] == -1:
      steps += 1
      run_step(moons, axis)
      #echo "After ", steps, " steps:\n", pp_moons(moons), "\n"
      if cycle[axis] == -1 and initial[axis] == axis_state(moons, axis):
        #echo "Found ", axis, " cycle at ", steps
        cycle[axis] = steps

  return lcm(lcm(cycle[X], cycle[Y]), cycle[Z])

proc parseFile(ls: seq[string]): seq[Moon] =
  var res : seq[Moon]
  for line in ls:
    let v = line.split(",").map(
      proc (x: string): int64 =
        parseBiggestInt(strip(x, chars={' ', '<', '>', '=', 'x', 'y', 'z'}))
    )
    var m : Moon = [v[0], v[1], v[2], 0, 0, 0]
    res.add(m)
  return res

if runTests():
  assert part1(parseFile(aoclib.readLines("test1.txt")), 10) == 179
  assert part1(parseFile(aoclib.readLines("test2.txt")), 100) == 1940
  assert part2(parseFile(aoclib.readLines("test1.txt"))) == 2772
  assert part2(parseFile(aoclib.readLines("test2.txt"))) == 4686774924

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  let p1 = part1(parseFile(Lines(inp)), 1000)
  let p2 = part2(parseFile(Lines(inp)))
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
