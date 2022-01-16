import aoclib

type BusInfo = tuple
  num : int
  index : int

type Buses = tuple
  depTime : int
  buses : seq[BusInfo]

proc initBuses(inp : seq[string]) : Buses =
  var buses : seq[BusInfo] = @[]
  var bs = inp[1].split(",")
  for bi in countup(0, bs.len-1):
    if bs[bi][0] == 'x':
      continue
    var binfo = (num: parseInt(bs[bi]), index: bi)
    buses.add(binfo)
  return (parseInt(inp[0]), buses)

proc part1(b : Buses) : int =
  var times = b.buses.map(bi => (num: bi.num,
                                 dt: bi.num-(b.depTime mod bi.num)))
  times.sort((a, b) => cmp(a.dt, b.dt))
  return times[0].num * times[0].dt

proc part2(b : Buses) : int =
  var first = b.buses[0]
  var t = first.index
  var period = first.num
  var offset = -1
  for i in countup(1, b.buses.len-1):
    var bus = b.buses[i].num
    var bus_t = b.buses[i].index
    offset = -1
    while true:
      if ((t+bus_t) mod bus) == 0:
        if offset == -1:
          offset = t
        else:
          period = t - offset
          break
      t += period
  return offset

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var b = initBuses(Lines(inp))
  let p1 = b.part1()
  let p2 = b.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
