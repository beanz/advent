require "aoc-lib.cr"

def fuel(m)
  (m / 3).to_i64 - 2
end

def fuelr(m)
  tm = m
  s = 0
  while true
    f = fuel(tm)
    if f <= 0
      break
    end
    s += f
    tm = f
  end
  return s
end

def part1(masses)
  masses.sum { |x| fuel(x) }
end

def part2(masses)
  masses.sum { |x| fuelr(x) }
end

aeq(part1([14]), 2)
aeq(part1([1969]), 654)
aeq(part1([100756]), 33583)
aeq(part1([12, 14, 1969, 100756]), 34241)

aeq(part2([14]), 2)
aeq(part2([1969]), 966)
aeq(part2([100756]), 50346)
aeq(part2([12, 14, 1969, 100756]), 51316)

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  masses = inputlines(inp).map &.to_i64
  p1 = part1(masses)
  p2 = part2(masses)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
