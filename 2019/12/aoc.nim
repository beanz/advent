import strutils, sequtils, math

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
  var s = ""
  for m in moons:
    s &= $m[axis] & "!" & $m[VX+axis] & "\n"
  return s

proc run_step(moons : var seq[Moon]): void =
  for i in 0..len(moons)-1:
    for j in i..len(moons)-1:
      for axis in { X, Y, Z }:
        if moons[i][axis] > moons[j][axis]:
          moons[i][VX+axis] -= 1
          moons[j][VX+axis] += 1
        elif moons[i][axis] < moons[j][axis]:
          moons[i][VX+axis] += 1
          moons[j][VX+axis] -= 1
  for i in 0..len(moons)-1:
    for axis in { X, Y, Z }:
      moons[i][axis] += moons[i][VX+axis]

proc part1(c_moons: seq[Moon], steps : int64): int64 =
  var moons = c_moons
  for step in 1..steps:
    run_step(moons)
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
  while cycle[X] == -1 or cycle[Y] == -1 or cycle[Z] == -1:
    steps += 1
    run_step(moons)
    #echo "After ", steps, " steps:\n", pp_moons(moons), "\n"
    for axis in { X, Y, Z }:
      if cycle[axis] == -1 and initial[axis] == axis_state(moons, axis):
        #echo "Found ", axis, " cycle at ", steps
        cycle[axis] = steps

  return lcm(lcm(cycle[X], cycle[Y]), cycle[Z])

proc readFile(file : string): seq[Moon] =
  var res : seq[Moon]
  for line in lines file:
    let v = line.split(",").map(
      proc (x: string): int64 =
        parseBiggestInt(strip(x, chars={' ', '<', '>', '=', 'x', 'y', 'z'}))
    )
    var m : Moon = [v[0], v[1], v[2], 0, 0, 0]
    res.add(m)
  return res

assert part1(readFile("test1a.txt"), 10) == 179
assert part1(readFile("test1b.txt"), 100) == 1940

echo "Part 1: ", part1(readFile("input.txt"), 1000)

assert part2(readFile("test1a.txt")) == 2772
assert part2(readFile("test2.txt")) == 4686774924

echo "Part 2: ", part2(readFile("input.txt"))
