inp = File.read("input.txt").rstrip("\n").chars()

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

def part1(inp, w, h)
  layers = inp.in_groups_of(w*h)
  min = layers.min_by { |l| l.count('0') }
  return min.count('1') * min.count('2')
end

def part2(inp, w, h)
  l = w*h
  s = ""
  (0...h).each { |y|
    (0...w).each { |x|
      i = y*w + x
      while i < inp.size()
        if inp[i] == '0'
          s += ' '
          break
        elsif inp[i] == '1'
          s += '#'
          break
        end
        i += l
      end
    }
    s += "\n"
  }
  return s
end

aeq(part1("0222112222120000".chars, 2, 2), 4)
aeq(part2("0222112222120000".chars, 2, 2), " #\n# \n")

print "Part1: ", part1(inp, 25, 6), "\n"
print "Part2:\n", part2(inp, 25, 6), "\n"
