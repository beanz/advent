require "aoc-lib.cr"

def part1(inp, bits)
  total = inp.size
  gamma = 0
  bit = 1 << bits
  while bit >= 1
    c = 0
    inp.each do |n|
      if (n & bit) != 0
        c+=1
      end
    end
    if c*2 > total
      gamma += bit
    end
    bit >>= 1
  end

  return gamma * ((2 << bits)-1-gamma)
end

def match(inp, val, mask)
  inp.each do |n|
    if (n & mask) == val
      return n
    end
  end
  return -1
end

def reduce(inp, bits, most)
  val = 0
  mask = 0

  bit = 1 << bits
  while bit >= 1
    c = 0
    total = 0
    inp.each do |n|
      if (n & mask) == val
        total += 1
        if (n & bit) != 0
          c += 1
        end
      end
    end
    if total == 1
      return match(inp, val, mask)
    end
    if (c*2 >= total) == most
      val += bit
    end
    mask += bit
    bit >>= 1
  end
  return val
end

def part2(inp, bits)
  return reduce(inp, bits, true) * reduce(inp, bits, false)
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  lines = inputlines(inp)
  bits = lines[0].size-1
  inp = lines.map do |x| x.to_i(2) end
  p1 = part1(inp, bits)
  p2 = part2(inp, bits)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
