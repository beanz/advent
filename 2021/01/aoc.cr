require "aoc-lib.cr"

scan = readinputints()

print "Part 1: ", scan.each_cons(2).count {|(a,b)| a < b }, "\n"
print "Part 2: ", scan.each_cons(4).count {|(a,b,c,d)| a < d }, "\n"
