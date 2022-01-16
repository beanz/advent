import os, strutils, sequtils, intsets,
       sugar, tables, sets, parseutils, math, deques, algorithm,
       point, bitops, hashes, strformat, random
export strutils, sequtils, intsets,
       sugar, tables, sets, parseutils, math, deques, algorithm,
       point, bitops, hashes, strformat, random

proc input*(embedded: string): string =
  if paramCount() > 0:
    return open(paramStr(1)).readAll()
  else:
    return embedded

import std/[times, monotimes]

proc bench*(): bool =
  return getEnv("AoC_BENCH", "0") == "1"

proc benchme*(embedded: string, fun: (string, bool) -> void): void =
  let inp = input(embedded)
  let start = getMonoTime()
  let is_bench = bench()
  let bench_time = initDuration(seconds = 1)
  var iterations = 0'i64
  while true:
    fun(inp, is_bench)
    iterations += 1
    if not is_bench:
      break
    let elapsed = getMonoTime() - start
    if elapsed > bench_time:
      echo "bench ", iterations, " iterations in ", elapsed.inNanoseconds, "ns: ", elapsed.inNanoseconds.float64/iterations.float64, "ns"
      break

proc debug*(): bool =
  return getEnv("AoC_DEBUG", "0") == "1"

proc runTests*(): bool =
  return getEnv("AoC_TEST", "0") == "1"

proc inputFile*(): string =
  if paramCount() > 0:
    return paramStr(1)
  else:
    return "input.txt"

proc isTest*(): bool =
  return inputFile() != "input.txt"

proc UInts*(s: string): seq[uint] =
  return s.strip(chars = {'\n'}).split({'\n',' ', ','}).map(parseUInt)

proc UInt8s*(c : string) : seq[uint8] =
  var s : seq[uint8]
  for ch in c.strip(chars = {'\n'}):
    s.add(cast[uint8](ch) - 48)
  return s

proc Int64s*(s: string): seq[int64] =
  return s.strip(chars = {'\n'}).split({'\n',' ', ','}).map(parseBiggestInt).mapIt(it.int64)

proc Ints*(s: string): seq[int] =
  return s.strip(chars = {'\n'}).split({'\n',' ', ','}).map(parseInt)

proc Lines*(s: string): seq[string] =
  return s.strip(chars = {'\n'}).split("\n")

proc Chunks*(s: string): seq[string] =
  return s.strip(chars = {'\n'}).split("\n\n")

proc ChunkyRecords*(s: string): seq[Table[string,string]] =
  var inp: seq[Table[string,string]]
  for chunk in Chunks(s):
    var m = initTable[string,string]()
    for v in chunk.split({'\n', ' '}):
      var ss = v.split(':')
      m[ss[0]] = ss[1]
    inp.add(m)
  return inp

proc Lists*(s: string): seq[seq[string]] =
  return Lines(s).map(l => l.split({'-',',',':',' '}))

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

proc readUInts*(file: string): seq[uint] =
  let f = open(file)
  return f.readAll().strip(chars = {'\n'}).split({'\n',' ', ','}).map(parseUInt)

proc readInputUInts*(): seq[uint] =
  return readUInts(inputFile())

proc readInt64s*(file: string): seq[int64] =
  let f = open(file)
  return f.readAll().strip(chars = {'\n'}).split({'\n',' ', ','}).map(parseBiggestInt)

proc readInputInt64s*(): seq[int64] =
  return readInt64s(inputFile())

proc readUInt64s*(file: string): seq[uint64] =
  let f = open(file)
  return f.readAll().strip(chars = {'\n'}).split({'\n',' ', ','}).map(parseBiggestUInt)

proc readInputUInt64s*(): seq[uint64] =
  return readUInt64s(inputFile())

proc readUInt8s*(file : string) : seq[uint8] =
  let f = open(file)
  var line1 = f.readLine()
  var s : seq[uint8]
  for ch in line1:
    s.add(cast[uint8](ch) - 48)
  return s

proc readInputUInt8s*() : seq[uint8] =
  return readUInt8s(inputFile())

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
