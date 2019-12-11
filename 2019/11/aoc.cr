prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64

class Inst
  getter param
  getter addr
  property op : Int64

  def initialize(op : Int64)
    @op = op
    @param = Array(Int64).new
    @addr = Array(Int64).new
  end
end

def opArity(op : Int64)
  if op == 99
    return 0
  end
  r = [0,3,3,1,1,2,2,3,3,1][op]
  return r
end

class IntComp
  property ip : Int64
  property inp : Deque(Int64)
  property outp : Deque(Int64)
  property done : Bool
  property base : Int64

  def initialize(prog : Array(Int64))
    @prog = prog
    @ip = 0
    @inp = Deque(Int64).new(5)
    @outp = Deque(Int64).new(5)
    @done = false
    @base = 0
  end

  def sprog(i)
    while @prog.size() <= i
      @prog << 0
    end
    return @prog[i]
  end

  def parseInst()
    rawop = @prog[@ip]
    @ip += 1
    inst = Inst.new(rawop%100)
    mode : Array(Int64) =
      [(rawop // 100) % 10, (rawop // 1000) % 10, (rawop // 10000) % 10]
    (0..opArity(inst.op)-1).each do |i|
      case mode[i]
      when 1
        inst.param << @prog[@ip]
        inst.addr << -99
      when 2
        inst.param << sprog(@base+@prog[@ip])
        inst.addr << @base+@prog[@ip]
      else
        inst.param << sprog(@prog[@ip])
        inst.addr << @prog[@ip]
      end
      @ip += 1
    end
    return inst
  end

  def run()
    while @ip < @prog.size()
      inst = parseInst()
      case inst.op
      when 1
        @prog[inst.addr[2]] = inst.param[0] + inst.param[1]
      when 2
        @prog[inst.addr[2]] = inst.param[0] * inst.param[1]
      when 3
        if @inp.size() == 0
          @prog[inst.addr[0]] = 0
        else
          @prog[inst.addr[0]] = @inp.shift()
        end
      when 4
        @outp.push(inst.param[0])
        return 0
      when 5
        if inst.param[0] != 0
          @ip = inst.param[1]
        end
      when 6
        if inst.param[0] == 0
          @ip = inst.param[1]
        end
      when 7
        if inst.param[0] < inst.param[1]
          @prog[inst.addr[2]] = 1
        else
          @prog[inst.addr[2]] = 0
        end
      when 8
        if inst.param[0] == inst.param[1]
          @prog[inst.addr[2]] = 1
        else
          @prog[inst.addr[2]] = 0
        end
      when 9
        @base += inst.param[0]
      when 99
        @done = true
        return 1
      else
        @done = true
        return -1
      end
    end
    @done = true
    return -2
  end
end

struct Point
  property x, y
  def initialize(@x : Int32, @y : Int32)
  end
end

struct Direction
  property x, y
  def initialize(@x : Int32, @y : Int32)
  end

  def cw()
    if @x == 0 && @y == -1
      @x = 1
      @y = 0
    elsif @x == 1 && @y == 0
      @x = 0
      @y = 1
    elsif @x == 0 && @y == 1
      @x = -1
      @y = 0
    else # @x == -1 && @y == 0
      @x = 0
      @y = -1
    end
  end

  def ccw()
    if @x == 0 && @y == -1
      @x = -1
      @y = 0
    elsif @x == 1 && @y == 0
      @x = 0
      @y = -1
    elsif @x == 0 && @y == 1
      @x = 1
      @y = 0
    else # @x == -1 && @y == 0
      @x = 0
      @y = 1
    end
  end
end

class Hull
  property m
  property min
  property max
  def initialize()
    @m = Hash(Point, Bool).new
    @dir = Direction.new(0,-1)
    @pos = Point.new(0,0)
    @min = Point.new(0,0)
    @max = Point.new(0,0)
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

  def updateBoundingBox()
    if @pos.x > @max.x
      @max.x = @pos.x
    end
    if @pos.x < @min.x
      @min.x = @pos.x
    end
    if @pos.y > @max.y
      @max.y = @pos.y
    end
    if @pos.y < @min.y
      @min.y = @pos.y
    end
  end

  def process(col, turn)
    output(col)
    if turn == 1
      @dir.cw()
    else
      @dir.ccw()
    end
    @pos.x += @dir.x
    @pos.y += @dir.y
    updateBoundingBox()
  end
end

def run(prog, input)
  h = Hull.new()
  ic = IntComp.new(prog.clone)
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
  (h.min.y .. h.max.y).each do |y|
    (h.min.x .. h.max.x).each do |x|
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

print "Part1: ", part1(prog), "\n"
print "Part2:\n", part2(prog), "\n"
