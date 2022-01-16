import aoclib

type MaskInst = object
  m0 : int64
  m1 : int64
  mx : int64

proc initMaskInst(mask : string) : MaskInst =
  var m0 = 0
  var m1 = 0
  var mx = 0
  for ch in mask:
    m0 = m0 shl 1
    m1 = m1 shl 1
    mx = mx shl 1
    case ch
    of '1':
      m1 += 1
      m0 += 1
    of 'X':
      mx += 1
      m0 += 1
    of '0':
      discard
    else:
      raise newException(ValueError, "invalid mask: " & mask)
  return MaskInst(m0: m0, m1: m1, mx: mx)

method value(m: MaskInst, v: int64) : int64 {.base.} =
  return (v or m.m1) and m.m0

method addrs(m: MaskInst, a: int64) : seq[int64] {.base.} =
  var addrs : seq[int64] = @[a or m.m1]
  var b : int64 = 1 shl 35
  while b >= 1:
    if (b and m.mx) != 0:
      for i in countup(0, addrs.len-1):
        var a = addrs[i]
        if (a and b) != 0:
          addrs.add(a and (0xfffffffff xor b))
        else:
          addrs.add(a or b)
    b = b shr 1
  return addrs

type MemInst = object
  add: int64
  val: int64

proc initMemInst(mem: string) : MemInst =
  var ss = mem[4..^1].split("] = ")
  return MemInst(add: parseBiggestInt(ss[0]), val: parseBiggestInt(ss[1]))

type
  InstKind = enum ikMask, ikMem
  Inst {.final, shallow.} = object
    case kind: InstKind
    of ikMask:
      mask: MaskInst
    of ikMem:
      mem: MemInst

type Mem = object
  inst : seq[Inst]

proc initMem(inp : seq[string]) : Mem =
  var inst : seq[Inst] = @[]
  for l in inp:
    if l[1] == 'a':
      inst.add(Inst(kind: ikMask, mask: initMaskInst(l[7..^1])))
    else:
      inst.add(Inst(kind: ikMem, mem: initMemInst(l)))
  return Mem(inst: inst)

method part1(s:Mem) : int64 {.base.} =
  var mem = initTable[int64,int64]()
  var curMask : MaskInst = initMaskInst("")
  for i in s.inst:
    case i.kind:
    of ikMask:
      curMask = i.mask
    of ikMem:
      var v = curMask.value(i.mem.val)
      mem[i.mem.add] = v
  var res : int64 = 0
  for v in mem.values:
    res += v
  return res

method part2(s:Mem) : int64 {.base.} =
  var mem = initTable[int64,int64]()
  var curMask : MaskInst = initMaskInst("")
  for i in s.inst:
    case i.kind:
    of ikMask:
      curMask = i.mask
    of ikMem:
      for a in curMask.addrs(i.mem.add):
        mem[a] = i.mem.val
  var res : int64 = 0
  for v in mem.values:
    res += v
  return res

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var m = initMem(Lines(inp))
  let p1 = m.part1()
  let p2 = m.part2()
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
