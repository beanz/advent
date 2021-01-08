import os, strutils, sequtils, intsets, sugar, sequtils, tables, sets
export strutils, sequtils, intsets, sugar, sequtils, tables, sets

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

proc readInts*(file: string): seq[int64] =
  let f = open(file)
  return f.readAll().strip(chars = {'\n'}).split({'\n',' ', ','}).map(parseBiggestInt)

proc readInputInts*(): seq[int64] =
  return readInts(inputFile())

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
