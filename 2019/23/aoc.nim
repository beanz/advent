import input, intcode, os, deques

proc part1(prog: seq[int64]): int64 =
  var ic : seq[IntCode]
  for i in countup(int64(0), 49):
    ic.add(NewIntCode(prog, i))
  while true:
    for i in countup(int64(0), 49):
      var rc = ic[i].Run()
      if rc == 0:
        let outp = ic[i].Output(3)
        if len(outp) >= 3:
          let a = outp[0]
          let x = outp[1]
          let y = outp[2]
          #echo "received ", a, " ", x, ",", y
          if a == 255:
            return y
          elif a < 50:
            ic[a].AddInput(x, y)
      elif rc == 2:
        ic[i].AddInput(-1)
  return 1

proc part2(prog: seq[int64]): int64 =
  var ic : seq[IntCode]
  for i in countup(int64(0), 49):
    ic.add(NewIntCode(prog, i))
  var natX : int64 = 0
  var natY : int64 = 0
  var lastY : int64 = -1
  while true:
    var idle = 0
    for i in countup(int64(0), 49):
      var rc = ic[i].Run()
      if rc == 0:
        let outp = ic[i].Output(3)
        if len(outp) >= 3:
          let a = outp[0]
          let x = outp[1]
          let y = outp[2]
          #echo "received ", a, " ", x, ",", y
          if a == 255:
            natX = x
            natY = y
          elif a < 50:
            ic[a].AddInput(x, y)
      elif rc == 2:
        idle += 1
        ic[i].AddInput(-1)
    if idle == 50:
      if lastY == natY:
        return natY
      lastY = natY
      ic[0].AddInput(natX, natY)
  return 2

var file = "input.txt"
if paramCount() > 0:
  file=paramStr(1)

var prog = readInts(file)
echo "Part 1: ", part1(prog)
echo "Part 2: ", part2(prog)
