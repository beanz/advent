import aoclib

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var ls = Lines(inp)
  var seatIds = ls.map(x => mustParseBin(x.multiReplace({ "B": "1", "F": "0",
                                                          "R": "1", "L": "0"
  })))
  var mx = max(seatIds)
  let p1 = mx
  var mn = min(seatIds)
  var expSum = (mn+mx)*(1+mx-mn) div 2
  var sum = sum(seatIds)
  let p2 = expSum-sum
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)
