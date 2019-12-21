import strutils, sequtils

proc readInts*(file : string) : seq[int64] =
  let f = open(file)
  return f.readLine().split(',').map(parseBiggestInt)

proc readLines*(file : string): seq[string] =
  var inp: seq[string]
  for line in lines file:
    inp.add(line)
  return inp
