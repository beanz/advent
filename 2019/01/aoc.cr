masses = File.read("input.txt").rstrip("\n").split("\n").map &.to_i64

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

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

print "Part1: ", part1(masses), "\n"

aeq(part2([14]), 2)
aeq(part2([1969]), 966)
aeq(part2([100756]), 50346)
aeq(part2([12, 14, 1969, 100756]), 51316)

print "Part2: ", part2(masses), "\n"
