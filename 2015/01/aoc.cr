require "aoc-lib.cr"

def part1(s)
  return s.count('(')-s.count(')')
end

def part2(s)
  f = 0
  i = 0
  s.each_char do |ch|
    if ch == '('
      f += 1
    else
      f -= 1
      if f < 0
        return i + 1
      end
    end
    i += 1
  end
  return -1
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  p1 = part1(inp)
  p2 = part2(inp)
  if !bench
    print "part 1: ", p1, "\n"
    print "part 2: ", p2, "\n"
  end
end
