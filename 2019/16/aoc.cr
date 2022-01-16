require "aoc-lib.cr"

REP = [0, 1, 0, -1]

def readinput(file)
  return parse(File.read(file))
end

def parse(s)
  s.rstrip("\n").bytes().map do |c| c-48 end
end

def calc1(s)
  o = Array(UInt8).new
  (1..s.size()).each do |i|
    n = 0
    (0..s.size()-1).each do |j|
      di = (1 + j) // i
      m = REP[di%4]
      d = s[j].to_i64 * m
      n += d
    end
    if n < 0
      n *= -1
    end
    n %= 10
    o << n.to_u8
  end
  return o
end

def digits(s, n)
  str = ""
  (0..n-1).each do |i|
    str += (s[i] + 48).unsafe_chr()
  end
  return str
end

def part1(inp, phases)
  s = inp
  (1..phases).each do |ph|
    s = calc1(s)
    #print "Phase ", ph, " Signal: ", digits(s, 8), "\n"
  end
  return digits(s, 8)
end

def offset(s, n)
  r = 0
  (0..n-1).each do |i|
    r *= 10
    r += s[i].to_i64
  end
  return r
end

def calc2(s)
  o = Array(UInt8).new
  ps = s.map do |i| i.to_i64 end.sum
  (0..s.size()-1).each do |i|
    n = ps
    if n < 0
      n *= -1
    end
    n %= 10
    o << n.to_u8
    ps -= s[i].to_i64
  end
  return o
end

def part2(inp)
  off = offset(inp, 7)
  inp10000 = inp * 10000
  s = inp10000[off..-1]
  (1..100).each do |ph|
    s = calc2(s)
  end
  return digits(s, 8)
end

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

if ENV.has_key?("AoC_TEST")
  aeq(part1(readinput("test1a.txt"), 4), "01029498")
  aeq(part1(readinput("test1b.txt"), 100), "24176176")
  aeq(part1(readinput("test1c.txt"), 100), "73745418")
  aeq(part1(readinput("test1d.txt"), 100), "52432133")
  aeq(part2(readinput("test2a.txt")), "84462026")
  aeq(part2(readinput("test2b.txt")), "78725270")
  aeq(part2(readinput("test2c.txt")), "53553731")
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  g = parse(inp)
  p1 = part1(g, 100)
  p2 = part2(g)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
