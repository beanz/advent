require "aoc-lib.cr"
require "intcode.cr"
require "point.cr"

class Scaffold
  property m
  property bb
  property bot
  property dir
  def initialize()
    @m = Hash(Point, Bool).new
    @bb = BoundingBox.new
    @pos = Point.new(0,0)
    @bot = Point.new(-1,-1)
    @dir = Direction.new(0,-1)
  end
  def isPipe(p : Point)
    return m.fetch(p, false)
  end
  def string()
    s = ""
    (@bb.min.y .. @bb.max.y).each do |y|
      (@bb.min.x .. @bb.max.x).each do |x|
        if x == @bot.x && y == @bot.y
          s += "^"
        elsif isPipe(Point.new(x,y))
          s += "#"
        else
          s += '.'
        end
      end
      s += "\n"
    end
    return s
  end
  def alignmentSum()
    ans = 0_i64
    (@bb.min.y .. @bb.max.y).each do |y|
      (@bb.min.x .. @bb.max.x).each do |x|
        if isPipe(Point.new(x,y)) &&
           isPipe(Point.new(x-1,y)) &&
           isPipe(Point.new(x,y-1)) &&
           isPipe(Point.new(x+1,y)) &&
           isPipe(Point.new(x,y+1))
          ans += x * y
        end
      end
    end
    return ans
  end
end

def part1(prog)
  scaff = Scaffold.new()
  ic = IntCode.new(prog.clone)
  outp = ic.runToHalt()
  pos = Point.new(0,0)
  outp.each do |ascii|
    case ascii
    when 10
      pos.x = 0
      pos.y += 1
    when 35
      scaff.m[pos] = true
      pos.x += 1
    when 94
      scaff.m[pos] = true
      scaff.bot = Point.new(pos.x, pos.y)
      pos.x += 1
    else
      pos.x += 1
    end
    scaff.bb.add(pos)
  end
  return scaff
end

def nextFunc(path, off, ch)
  shortest = Int32::MAX
  fn = ""
  (1..22).each do |i|
    sub = path[off..off+i]
    t = path.gsub(sub, ch)
    if shortest > t.size()
      shortest = t.size()
      fn = sub
    end
  end
  return fn.rstrip(",RL")
end

def part2(prog, scaff)
  pos = scaff.bot
  dir = scaff.dir
  path = Deque(Int64).new(50)
  while true
    np = pos.in(dir)
    if scaff.isPipe(np)
      pos = np
      if path.size() > 0 && path.last > 0
        l = path.pop
        path << l+1
      else
        path << 1
      end
    else
      left = dir.ccw()
      np = pos.in(left)
      if scaff.isPipe(np)
        dir = left
        path << -1 # -1 == left
      else
        right = dir.cw()
        np = pos.in(right)
        if scaff.isPipe(np)
          dir = right
          path << -2 # -2 == right
        else
          break
        end
      end
    end
  end
  pathStr = ""
  first = true
  path.each do |m|
    if !first
      pathStr += ','
    end
    first = false
    if m > 0
      pathStr += "#{m}"
    elsif m == -1
      pathStr += 'L'
    elsif m == -2
      pathStr += 'R'
    end
  end
  fnA = nextFunc(pathStr, 0, 'A')
  pathStr = pathStr.gsub(fnA, 'A')
  off = 0
  while pathStr[off] == 'A' || pathStr[off] == ','
    off += 1
  end
  fnB = nextFunc(pathStr, off, 'B')
  pathStr = pathStr.gsub(fnB, 'B')
  while pathStr[off] == 'A' || pathStr[off] == 'B' || pathStr[off] == ','
    off += 1
  end
  fnC = nextFunc(pathStr, off, 'C')
  fnM = pathStr.gsub(fnC, 'C')

  full = [fnM, fnA, fnB, fnC, "n\n"].join("\n")

  prog[0] = 2
  ic = IntCode.new(prog, full)
  outp = ic.runToHalt()
  return outp.last
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  prog = inp.rstrip("\n").split(",").map &.to_i64
  scaff = part1(prog);
  p1 = scaff.alignmentSum()
  p2 = part2(prog, scaff)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
