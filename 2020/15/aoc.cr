require "aoc-lib.cr"

class Game
  property nums : Array(Int64)
  def initialize(inp)
    @nums = inp
  end
  def calc(turns)
    seen = Array(Int32).new(turns, -1)
    n = 0
    p = 0
    (0..@nums.size-1).each do |i|
      n = @nums[i]
      if i > 0
        seen[p] = i+1
      end
      p = n
    end
    (@nums.size+1..turns).each do |t|
      if seen[p] > 0
        n = t-seen[p]
      else
        n = 0
      end
      seen[p] = t
      p = n
    end
    return n
  end
  def part1()
    return calc(2020)
  end
  def part2()
    return calc(30000000)
  end
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  g = Game.new(inp.split(",").map &.to_i64)
  p1 = g.part1()
  p2 = g.part2()
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
