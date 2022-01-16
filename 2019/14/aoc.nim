import aoclib

type Input = object
  ch: string
  num: int64

type Reaction = object
  num: int64
  inputs: seq[Input]

type Factory = object
    reactions: Table[string, Reaction]
    surplus: Table[string, int64]
    total: Table[string, int64]

proc quant_chem(s: string) : (string, int64) =
  let splits = s.split(" ")
  return (splits[1], parseBiggestInt(splits[0]))

proc NewFactory(lines: seq[string]) : Factory =
  var reactions = initTable[string, Reaction]()
  var surplus = initTable[string, int64]()
  var total = initTable[string, int64]()
  for line in lines:
    let splits = line.split(" => ")
    let (out_name, out_num) = quant_chem(splits[1])
    var inputs : seq[Input]
    for in_elt in splits[0].split(", "):
      let (in_name, in_num) = quant_chem(in_elt)
      inputs.add(Input(ch: in_name, num: in_num))
    reactions[out_name] = Reaction(num: out_num, inputs: inputs)
  return Factory(reactions: reactions, surplus: surplus, total: total)

method factory_reset(this : var Factory): void {.base.} =
  this.surplus.clear()
  this.total.clear()

method get_surplus(this : Factory, ch : string): int64 {.base.} =
  if this.surplus.hasKey(ch):
    return this.surplus[ch]
  return 0

method use_surplus(this : var Factory,
                   ch : string, num : int64): void {.base.} =
  if not this.surplus.hasKey(ch):
    this.surplus[ch] = 0
  this.surplus[ch] -= num

method produce(this : var Factory,
               ch : string, num : int64): void {.base.} =
  if not this.total.hasKey(ch):
    this.total[ch] = 0
  this.total[ch] += num

proc ceildiv(a : int64, b : int64): int64 =
  var n = a div b
  if a mod b != 0:
    n += 1
  return n

method requirements(this : var Factory,
                    ch : string, needed_c : int64): void {.base.} =
  if ch == "ORE":
    return
  var needed = needed_c
  let r = this.reactions[ch]
  let avail = this.get_surplus(ch)
  if avail > needed:
    this.use_surplus(ch, needed)
    return
  if avail > 0:
    needed -= avail
    this.use_surplus(ch, avail)
  let required = ceildiv(needed, r.num)
  let surplus = r.num * required - needed
  this.use_surplus(ch, -surplus) # negative use!
  for inp in r.inputs:
    this.produce(inp.ch, inp.num*required)
    this.requirements(inp.ch, inp.num*required)

method ore_for(this : var Factory, num : int64): int64 {.base.} =
  this.requirements("FUEL", num)
  return this.total["ORE"]

method part1(this : var Factory): int64 {.base.} =
  return this.ore_for(1)

method part2(this : var Factory): int64 {.base.} =
  let target = 1000000000000
  var upper : int64 = 1
  while this.ore_for(upper) < target:
    this.factory_reset()
    upper *= 2
  var lower = upper div 2
  while true:
    var mid = lower + (upper - lower) div 2
    if mid == lower:
      break
    this.factory_reset()
    if this.ore_for(mid) > target:
      upper = mid
    else:
      lower = mid
  return lower

proc readFile(file : string): seq[string] =
  var lines : seq[string]
  for line in lines file:
    lines.add(line)
  return lines

var tf = NewFactory(readFile("test1a.txt"))
assert tf.part1() == 31
assert tf.part2() == 34482758620
tf = NewFactory(readFile("test1b.txt"))
assert tf.part1() == 165
assert tf.part2() == 6323777403
tf = NewFactory(readFile("test1c.txt"))
assert tf.part1() == 13312
assert tf.part2() == 82892753
tf = NewFactory(readFile("test1d.txt"))
assert tf.part1() == 180697
assert tf.part2() == 5586022
tf = NewFactory(readFile("test1e.txt"))
assert tf.part1() == 2210736
assert tf.part2() == 460664

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var f = NewFactory(Lines(inp))
  let p1 = f.part1()
  let p2 = f.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
