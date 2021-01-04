require "aoc-lib.cr"

inp = readinputchunks().map { |x| x.split("\n").map { |y| y.split("") } }

print "Part 1: ", inp.map { |x| x.flatten.uniq.size }.sum, "\n"
inp_sets = inp.map { |x| x.map { |y| Set.new(y) } }
intersect = inp_sets.map {|x| x.reduce(x.first) { |a, s| a & s } }
print "Part 2: ", (intersect.map &.size).sum, "\n"
