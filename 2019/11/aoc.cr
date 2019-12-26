require "../lib/intcode.cr"
require "../lib/point.cr"

class Hull
  property m
  property bb
  def initialize()
    @m = Hash(Point, Bool).new
    @dir = Direction.new(0,-1)
    @pos = Point.new(0,0)
    @bb = BoundingBox.new()
  end

  def input()
    if @m.fetch(@pos, false)
      return 1_i64
    else
      return 0_i64
    end
  end

  def output(val)
    @m[@pos] = val == 1
  end

  def process(col, turn)
    output(col)
    if turn == 1
      @dir = @dir.cw()
    else
      @dir = @dir.ccw()
    end
    @pos.x += @dir.x
    @pos.y += @dir.y
    @bb.add(@pos)
  end
end

def run(prog, input)
  h = Hull.new()
  ic = IntCode.new(prog.clone)
  ic.inp.push(input)
  while ic.run() != 1
    if ic.outp.size() == 2
      h.process(ic.outp.shift(), ic.outp.shift())
      ic.inp.push(h.input())
    end
  end
  return h
end

def part1(prog)
  h = run(prog,0_i64)
  return h.m.size()
end

def part2(prog)
  h = run(prog,1_i64)
  s = ""
  (h.bb.min.y .. h.bb.max.y).each do |y|
    (h.bb.min.x .. h.bb.max.x).each do |x|
      p = Point.new(x,y)
      if h.m.fetch(p, false)
        s += '#'
      else
        s += '.'
      end
    end
    s += "\n"
  end
  return s
end

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64
print "Part1: ", part1(prog), "\n"
print "Part2:\n", part2(prog), "\n"
