require "aoc-lib.cr"

pre : Int64 = 25
pre = 5 if istest?()

def part1(inp, pre : Int64 = 25)
  sums = Array(Array(Int64)).new
  (0 .. pre-2).each do |i|
    sumlist = inp[i+1 .. pre-1].map {|x| x + inp[i]}
    sums.push(sumlist)
  end
  (pre .. inp.size-1).each do |i|
    valid = sums.any? { |sl| sl.any? { |x| x == inp[i] } }
    return inp[i] unless valid
    sums.shift
    sums.each_index do |j|
      sums[j] << inp[i-pre+j+1]+inp[i]
    end
    sums << [ inp[i-1] + inp[i] ]
  end
  return -1
end

def part2(inp, target)
  si = 0
  ei = 2
  sum = inp[si..ei].sum
  while sum != target || si == (ei-1)
    if sum < target
      ei += 1
      sum += inp[ei]
    else
      sum -= inp[si]
      si += 1
    end
  end
  min = inp[si..ei].min
  max = inp[si..ei].max
  return min + max
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  ints = inputlines(inp).map &.to_i64

  p1 = part1(ints, pre)
  p2 = part2(ints, p1)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
