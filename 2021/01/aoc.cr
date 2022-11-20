require "aoc-lib.cr"

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  scan = inputlines(inp).map &.to_i64
  p1 = scan.each_cons(2).count {|(a,b)| a < b }
  p2 = scan.each_cons(4).count {|(a,b,c,d)| a < d }
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end

