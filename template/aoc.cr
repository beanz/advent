#require "../lib/intcode.cr"
#require "../lib/point.cr"

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

def readlines(file)
  File.read(file).rstrip("\n").split("\n")
end

def readints(file)
  File.read(file).rstrip("\n").split(",").map &.to_i64
end

file = "input.txt"
if ARGV.size > 0
  file = ARGV[0]
end

inp = readints(file)
orig_inp = inp.clone

if ENV.has_key?("AoC_TEST")
  aeq(part1([1,0,0,0,99]), 1)
end

print "Part1: ", part1(inp), "\n"

print "Part2: ", part2(orig_inp), "\n"
