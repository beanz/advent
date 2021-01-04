require "aoc-lib.cr"

seat_ids = readinputlines().map do |x|
  x.gsub(/([BFRL])/, {"B": 1, "F": 0, "R": 1, "L": 0}).to_i(2)
end

max = seat_ids.max
print "Part 1: ", max, "\n"

min = seat_ids.min
sum = seat_ids.sum
exp = (min+max)*(1+max-min)//2
print "Part 2: ", exp-sum, "\n"
