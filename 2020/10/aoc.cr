require "aoc-lib.cr"

def part1(inp)
  c1 = 0
  c3 = 0
  prev = 0
  inp.each_index do |i|
    d = inp[i]-prev
    case d
    when 1
      c1 +=1
    when 3
      c3 += 1
    end
    prev = inp[i]
  end
  return c1 * c3
end

def part2(inp)
  inc = (0..inp[inp.size-1]).map { |x| if inp.includes?(x) 1 else 0 end }
  trib = [0, 0, 1] of Int64
  inc.each do |e|
    s = trib.sum
    trib.shift
    trib << s * e
  end
  return trib[2]
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  ints = inputlines(inp).map &.to_i64
  ints = ints.sort
  ints << ints[ints.size-1] + 3

  p1 = part1(ints)
  p2 = part2(ints)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
