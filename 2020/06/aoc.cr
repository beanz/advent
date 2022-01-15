require "aoc-lib.cr"

def parts(inp) : {Int32, Int32}
  inp = inputchunks(inp).map { |x| x.split("\n").map { |y| y.split("") } }

  p1 = inp.map { |x| x.flatten.uniq.size }.sum
  inp_sets = inp.map { |x| x.map { |y| Set.new(y) } }
  intersect = inp_sets.map {|x| x.reduce(x.first) { |a, s| a & s } }
  return p1, (intersect.map &.size).sum
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  p1, p2 = parts(inp)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
