import aoclib

type
  Asteroid = object
    x: int
    y: int

proc hash(a : Asteroid): Hash =
  return hash(a.x) !& hash(a.y)

type
  AsteroidPair = object
    a1: Asteroid
    a2: Asteroid

proc hash(a : AsteroidPair): Hash =
  return hash(a.a1) !& hash(a.a2)

type
  AsteroidAngle = object
    asteroid: Asteroid
    angle: float

type
  Space = object
    best: Asteroid
    asteroids: HashSet[Asteroid]
    blockers: Table[AsteroidPair, int]

proc NewSpace(inp: seq[string]): Space =
  var a = initHashSet[Asteroid]()
  var best = Asteroid(x: -1, y: -1)
  var y = 0
  for line in inp:
    var x = 0
    for ch in line:
      if ch == '#':
        a.incl(Asteroid(x: x, y: y))
      if ch == 'X':
        best = Asteroid(x: x, y: y)
        a.incl(best)
      x += 1
    y += 1
  return Space(best: best, asteroids: a,
               blockers: initTable[AsteroidPair, int]())

proc numBlockers(space: var Space, a1 : Asteroid, a2 : Asteroid): int =
  let k = AsteroidPair(a1: a1, a2: a2)
  if space.blockers.hasKey(k):
    return space.blockers[k]
  var res = 0
  var dx = a2.x - a1.x
  var dy = a2.y - a1.y
  if dx != 0 or dy != 0:
     let gcd = dx.gcd(dy)
     dx = dx div gcd
     dy = dy div gcd
  var between = Asteroid(x: a1.x + dx, y: a1.y + dy)
  while between != a2:
    if space.asteroids.contains(between):
      res += 1
    between.x += dx
    between.y += dy
  space.blockers[k] = res
  let k2 = AsteroidPair(a1: a2, a2: a1) # since it is symmetric
  space.blockers[k2] = res
  return res

proc part1(s : var Space): int64 =
  var max = -2147483648
  for a1 in s.asteroids:
    var c = 0
    for a2 in s.asteroids:
      if a1 == a2:
        continue
      if s.numBlockers(a1, a2) == 0:
        c += 1
    if max < c:
      max = c
      s.best = a1
  return max

proc angle(s : Space, a : Asteroid): float =
  var angle = arctan2(float(a.x - s.best.x), float(s.best.y - a.y))
  while angle < 0:
    angle += PI * float(2)
  return angle

proc angleSort(aa1 : AsteroidAngle, aa2: AsteroidAngle): int =
  cmp(aa1.angle, aa2.angle)

proc part2(s: var Space, num : int): int64 =
  var angles : seq[AsteroidAngle]
  for a in s.asteroids:
    if s.best == a:
      continue
    var angle = s.angle(a)
    angle += float(s.num_blockers(s.best, a) * 2) * PI
    angles.add(AsteroidAngle(asteroid: a, angle: angle))
  sort(angles, angleSort)
  let nth = angles[num-1].asteroid
  return nth.x * 100 + nth.y

proc readFile(file : string): seq[string] =
  var inp: seq[string]
  for line in lines file:
    inp.add(line)
  return inp

var ts = NewSpace(@[".#..#",".....","#####","....#","...##"])
assert ts.numBlockers(Asteroid(x: 3, y: 4), Asteroid(x: 1, y: 0)) == 1
assert ts.numBlockers(Asteroid(x: 4, y: 4), Asteroid(x: 4, y: 2)) == 1
assert ts.numBlockers(Asteroid(x: 3, y: 4), Asteroid(x: 2, y: 2)) == 0
assert ts.numBlockers(Asteroid(x: 3, y: 4), Asteroid(x: 4, y: 0)) == 0
assert ts.numBlockers(Asteroid(x: 4, y: 4), Asteroid(x: 4, y: 0)) == 2
assert ts.numBlockers(Asteroid(x: 4, y: 4), Asteroid(x: 4, y: 3)) == 0
assert ts.part1() == 8

ts.best = Asteroid(x: 2, y: 2)
assert ts.angle(Asteroid(x: 2, y: 0)) == 0.0 # n
assert ts.angle(Asteroid(x: 4, y: 0)) == 0.7853981633974483 # ne
#assert ts.angle(Asteroid(x: 4, y: 2)) == 1.5707963267948970 # e
assert ts.angle(Asteroid(x: 4, y: 4)) == 2.356194490192345  # se
assert ts.angle(Asteroid(x: 2, y: 4)) == 3.141592653589793  # s
#assert ts.angle(Asteroid(x: 0, y: 4)) == 3.926990816987241  # sw
assert ts.angle(Asteroid(x: 0, y: 2)) == 4.71238898038469   # w
assert ts.angle(Asteroid(x: 0, y: 0)) == 5.497787143782138  # nw

if runTests():
  var testin: seq[string] = readFile("test2a.txt")
  ts = NewSpace(testin)
  let order = [801, 900, 901, 1000, 902, 1101, 1201, 1102, 1501]
  for i in countup(0, len(order)-1):
    assert ts.part2(i+1) == order[i]

var inp = readInputLines()
var space = NewSpace(inp)

echo "Part 1: ", space.part1()
echo "Part 2: ", space.part2(200)
