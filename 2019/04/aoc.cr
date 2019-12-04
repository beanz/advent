inp = File.read("input.txt").rstrip("\n").split("-").map &.to_i64

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

def part1(inp)
  c = 0
  (inp[0] .. inp[1]).each do |i|
    if i < 100000 || i > 999999
      next
    end
    s = i.to_s
    if s[0] > s[1] || s[1] > s[2] || s[2] > s[3] ||
       s[3] > s[4] || s[4] > s[5]
      next
    end
    if s =~ /(.)\1/
      c += 1
    end
  end
  return c
end

def part2(inp)
  c = 0
  (inp[0] .. inp[1]).each do |i|
    if i < 100000 || i > 999999
      next
    end
    s = i.to_s
    if s[0] > s[1] || s[1] > s[2] || s[2] > s[3] ||
       s[3] > s[4] || s[4] > s[5]
      next
    end
    if s =~ /^(?:.*(.)((?!\1).)\2(?!\2)|(.)\3(?!\3))/
      c += 1
    end
  end
  return c
end

aeq(part1([111111,111111]), 1)
aeq(part1([223450,223450]), 0)
aeq(part1([123789,123789]), 0)
aeq(part1([123444,123444]), 1)
aeq(part1([111122,111122]), 1)

print "Part1: ", part1(inp), "\n"

aeq(part2([112233,112233]), 1)
aeq(part2([123444,123444]), 0)
aeq(part2([111122,111122]), 1)

print "Part2: ", part2(inp), "\n"
