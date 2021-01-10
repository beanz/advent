import os, strutils, sequtils, intsets,
       sugar, sequtils, tables, sets, parseutils, math, deques, algorithm,
       point, bitops
export strutils, sequtils, intsets, sugar, sequtils,
       tables, sets, parseutils, math, deques, algorithm, point, bitops

proc debug*(): bool =
  return getEnv("AoC_DEBUG", "0") == "1"

proc inputFile*(): string =
  if paramCount() > 0:
    return paramStr(1)
  else:
    return "input.txt"

proc isTest*(): bool =
  return inputFile() != "input.txt"

proc readLines*(file: string): seq[string] =
  var inp: seq[string]
  for line in lines file:
    inp.add(line)
  return inp

proc readInputLines*(): seq[string] =
  return readLines(inputFile())

proc readChunks*(file: string): seq[string] =
  return open(file).readAll().strip(chars = {'\n'}).split("\n\n")

proc readInputChunks*(): seq[string] =
  return readChunks(inputFile())

proc readInts*(file: string): seq[int] =
  let f = open(file)
  return f.readAll().strip(chars = {'\n'}).split({'\n',' ', ','}).map(parseInt)

proc readInputInts*(): seq[int] =
  return readInts(inputFile())

proc readInt64s*(file: string): seq[int64] =
  let f = open(file)
  return f.readAll().strip(chars = {'\n'}).split({'\n',' ', ','}).map(parseBiggestInt)

proc readInputInt64s*(): seq[int64] =
  return readInt64s(inputFile())

proc readLists*(file: string): seq[seq[string]] =
  return readLines(file).map(l => l.split({'-',',',':',' '}))

proc readInputLists*(): seq[seq[string]] =
  return readLists(inputFile())

proc readChunkyRecords*(file: string): seq[Table[string,string]] =
  var inp: seq[Table[string,string]]
  for chunk in readChunks(file):
    var m = initTable[string,string]()
    for v in chunk.split({'\n', ' '}):
      var ss = v.split(':')
      m[ss[0]] = ss[1]
    inp.add(m)
  return inp

proc readInputChunkyRecords*(): seq[Table[string,string]] =
  return readChunkyRecords(inputFile())

proc mustParseBin*(s : string): int =
  var num : int = 0
  discard parseBin[int](s, num)
  return num

proc maxInt*(ints : seq[int]): int =
  var m : int = -2147483647
  for n in ints:
    if m < n:
      m = n
  return m

proc isqrt*(n : int) : int =
  if n < 0:
    raise newException(ValueError, "isqrt of negative is invalid: " & $(n))
  if n == 1:
    return n
  var b = fastLog2(n) + 1
  var x = (1 shl ((b-1) shr 1)) or (n shr ((b shr 1) + 1))
  var t : int = n div x
  while t < x:
    x = (x + t) shr 1
    t = n div x
  return x

proc rotateStrings*(lines : seq[string]) : seq[string] =
  let w = lines[0].len
  let h = lines.len
  var n : seq[string] = @[]
  for i in countup(0, w-1):
    var l = ""
    for j in countup(0, h-1):
      l &= lines[w-1-j][i]
    n.add(l)
  return n
