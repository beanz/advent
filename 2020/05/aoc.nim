import aoclib

var inp = readInputLines()
var seatIds = inp.map(x => mustParseBin(x.multiReplace({ "B": "1", "F": "0",
                                                         "R": "1", "L": "0"
                                                       })))
var mx = max(seatIds)
echo "Part 1: ", mx

var mn = min(seatIds)
var expSum = (mn+mx)*(1+mx-mn) div 2
var sum = sum(seatIds)
echo "Part 2: ", expSum-sum
