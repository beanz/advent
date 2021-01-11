import aoclib, intcode

proc part1(prog: seq[int64]): int64 =
  var blocks = 0
  proc noInput() : int64 =
    return 0
  proc countBlocks(ints : seq[int64]) =
    if ints[2] == 2:
      blocks += 1
  var ic = NewIntCode(prog)
  discard ic.RunWithCallbacks(noInput, countBlocks, 3)
  return blocks

proc part2(prog_c: seq[int64]): int64 =
  var prog: seq[int64]
  deepCopy(prog, prog_c)
  prog[0] = 2
  var ball : int64 = 0
  var paddle : int64 = 0
  var score : int64 = 0
  proc joystickInput() : int64 =
    if ball < paddle:
      return -1
    elif ball > paddle:
      return 1
    else:
      return 0
  proc playBreakout(ints : seq[int64]) =
    if ints[0] == -1 and ints[1] == 0:
      score = ints[2]
    elif ints[2] == 3:
      paddle = ints[0]
    elif ints[2] == 4:
      ball = ints[0]

  var ic = NewIntCode(prog)
  discard ic.RunWithCallbacks(joystickInput, playBreakout, 3)
  return score

var prog = readInputInt64s()
echo "Part 1: ", part1(prog)
echo "Part 2: ", part2(prog)
