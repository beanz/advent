require "aoc-lib.cr"

def parts(inp) : {Int32, Int32}
  seat_ids = inputlines(inp).map do |x|
    x.gsub(/([BFRL])/, {"B": 1, "F": 0, "R": 1, "L": 0}).to_i(2)
  end

  max = seat_ids.max
  min = seat_ids.min
  sum = seat_ids.sum
  exp = (min+max)*(1+max-min)//2
  return max, exp-sum
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  p1, p2 = parts(inp)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end

