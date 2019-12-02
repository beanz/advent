inp = File.read("input.txt").rstrip("\n").split(",").map &.to_i64

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

def part1(inp)
  return 1
end

def part2(inp)
  return 2
end
orig_inp = inp.clone

aeq(part1([1,0,0,0,99]), 1)

print "Part1: ", part1(inp), "\n"

print "Part2: ", part2(orig_inp), "\n"
