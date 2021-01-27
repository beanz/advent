require "aoc-lib.cr"

def part1(s)
  return s.count('(')-s.count(')')
end

def part2(s)
  f = 0
  s.each_char_with_index do |ch, i|
    if ch == '('
      f += 1
    else
      f -= 1
      if f < 0
        return i + 1
      end
    end
  end
  return -1
end

inp = readinputlines()[0]

print "Part1: ", part1(inp), "\n"
print "Part2: ", part2(inp), "\n"
