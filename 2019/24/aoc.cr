#require "intcode.cr"
#require "point.cr"

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

def bug(n, x, y)
  if (y < 0 || y >= 5 || x < 0 || x >= 5)
    return false
  end
  return (n & (1 << (y*5+x))) != 0
end

def life(n, x, y)
  c = 0
  if bug(n, x, y-1)
    c += 1
  end
  if bug(n, x-1, y)
    c += 1
  end
  if bug(n, x+1, y)
    c += 1
  end
  if bug(n, x, y+1)
    c += 1
  end
  return c == 1 || (!bug(n, x, y) && c == 2)
end

def pp1(n)
  return String.build do |str|
    i = 1
    (0..4).each do |y|
      (0..4).each do |x|
        if (n&i) != 0
          str << "#"
        else
          str << "."
        end
        i <<= 1
      end
      str << "\n"
    end
  end
end

def part1(lines)
  i = 1
  n = 0
  (0..4).each do |y|
    (0..4).each do |x|
      if lines[y][x] == '#'
        n += i
      end
      i <<= 1
    end
  end
  #printf "%d\n", n
  #print pp1(n), "\n";
  seen = Set.new [n]
  while true
    new = 0
    i = 1
    (0..4).each do |y|
      (0..4).each do |x|
        if life(n, x, y)
          new += i
        end
        i <<= 1
      end
    end
    if seen.includes?(new)
      return new
    end
    seen << new
    n = new
  end
  return -1
end

def bug2(m, d, x, y)
  if y < 0 || y >= 5 || x < 0 || x >= 5
    return false
  end
  return (m.fetch(d, 0) & (1 << (y*5+x))) != 0
end

def life2(m, d, x, y)
  c = 0

  # neighbour(s) above
  if y == 0
    if bug2(m, d-1, 2, 1)
      c += 1
    end
  elsif y == 3 && x == 2
    (0..4).each do |i|
      if bug2(m, d+1, i, 4)
        c += 1
      end
    end
  else
    if bug2(m, d, x, y-1)
      c += 1
    end
  end

  # neighbour(s) below
  if y == 4
    if bug2(m, d-1, 2, 3)
      c += 1
    end
  elsif y == 1 && x == 2
    (0..4).each do |i|
      if bug2(m, d+1, i, 0)
        c += 1
      end
    end
  else
    if bug2(m, d, x, y+1)
      c += 1
    end
  end

  # neighbour(s) left
  if x == 0
    if bug2(m, d-1, 1, 2)
      c += 1
    end
  elsif x == 3 && y == 2
    (0..4).each do |i|
      if bug2(m, d+1, 4, i)
        c += 1
      end
    end
  else
    if bug2(m, d, x-1, y)
      c += 1
    end
  end

  # neighbour(s) right
  if x == 4
    if bug2(m, d-1, 3, 2)
      c += 1
    end
  elsif x == 1 && y == 2
    (0..4).each do |i|
      if bug2(m, d+1, 0, i)
        c += 1
      end
    end
  else
    if bug2(m, d, x+1, y)
      c += 1
    end
  end

  return c == 1 || (!bug2(m, d, x, y) && c == 2)
end

def count(m)
  c = 0
  m.keys.each do |d|
    (0..4).each do |y|
      (0..4).each do |x|
        if !(x == 2 && y == 2) && bug2(m, d, x, y)
          c += 1
        end
      end
    end
  end
  return c
end

def part2(lines, min)
  i = 1
  n = 0
  (0..4).each do |y|
    (0..4).each do |x|
      if lines[y][x] == '#'
        n += i
      end
      i <<= 1
    end
  end
  m = Hash(Int32, Int32).new
  m[0] = n
  if min == 0
    return count(m)
  end
  (1..min).each do |t|
    newM = Hash(Int32, Int32).new
    minD = m.keys.min - 1
    maxD = m.keys.max + 1
    (minD..maxD).each do |depth|
      new = 0
      (0..4).each do |y|
        (0..4).each do |x|
          if x == 2 && y == 2
            next
          end
          if life2(m, depth, x, y)
            new += 1 << (y*5 + x)
          end
        end
      end
      newM[depth] = new
    end
    m = newM
  end
  return count(m)
end

def readlines(file)
  File.read(file).rstrip("\n").split("\n")
end

file = "input.txt"
if ARGV.size > 0
  file = ARGV[0]
end

lines = readlines(file)

if ENV.has_key?("AoC_TEST")
  aeq(part1(readlines("test.txt")), 2129920);
  aeq(part1(readlines("input.txt")), 6520863);
  aeq(part2(readlines("test.txt"), 1), 27);
  aeq(part2(readlines("test.txt"), 10), 99);
  aeq(part2(readlines("input.txt"), 1), 21);
  aeq(part2(readlines("input.txt"), 200), 1970);
end

print "Part1: ", part1(lines), "\n"
print "Part2: ", part2(lines, 200), "\n"
