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

  def cloneWithInput(input : Int64)
    ic = IntComp.new(@prog.clone)
    ic.inp << input
    ic.ip = @ip
    ic.base = @base
    return ic
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

struct BoundingBox
  property min, max
  def initialize()
    @min = Point.new(2147483647,2147483647)
    @max = Point.new(-2147483648,-2147483648)
  end
  def add(p : Point)
    if p.x < min.x
      min.x = p.x
    end
    if p.x > max.x
      max.x = p.x
    end
    if p.y < min.y
      min.y = p.y
    end
    if p.y > max.y
      max.y = p.y
    end
  end
end

class Ship
  property wall
  property bb
  property os
  property osic : IntComp | ::Nil
  property steps
  def initialize()
    @wall = Hash(Point, Bool).new
    @bb = BoundingBox.new
    @os = Point.new(0,0)
    @osic = nil
    @steps = 0
  end
  def string()
    s = ""
    (h.min.y .. h.max.y).each do |y|
      (h.min.x .. h.max.x).each do |x|
        p = Point.new(x,y)
        if x == 0 && y == 0
          s += "S"
        elsif os.x == x && os.y == y
          s += "O"
        elsif @wall.fetch(p, false)
          s += '#'
        else
          s += '.'
        end
      end
      s += "\n"
    end
    return s
  end
end

struct Search
  property pos
  property steps
  property ic
  def initialize(@pos : Point, @steps : Int32, @ic : IntComp)
  end
end

def compassToInput(dir)
  case dir
  when "N"
    return 1_i64
  when "S"
    return 2_i64
  when "W"
    return 3_i64
  else
    return 4_i64
  end
end

def compassXOffset(dir)
  case dir
  when "N"
    return 0
  when "S"
    return 0
  when "W"
    return -1
  else
    return 1
  end
end

def compassYOffset(dir)
  case dir
  when "N"
    return -1
  when "S"
    return 1
  when "W"
    return 0
  else
    return 0
  end
end

def tryDirection(ic : IntComp)
  while ic.run() != 1
    if ic.outp.size() == 1
      return ic
    end
  end
  return ic
end

def part1(prog)
  search = Deque(Search).new(100)
  ship = Ship.new()
  start = Point.new(0,0)
  ["N", "S", "W", "E"].each do |dir|
    np = Point.new(start.x + compassXOffset(dir),
                   start.y + compassYOffset(dir))
    nic = IntComp.new(prog.clone)
    nic.inp << compassToInput(dir)
    search << Search.new(np, 1, nic)
  end
  visited = Hash(Point, Bool).new
  while search.size() > 0
    cur = search.shift()
    cur.ic = tryDirection(cur.ic)
    res = cur.ic.outp.shift()
    if res == 0
      ship.wall[cur.pos] = true
    elsif res == 1
      ["N", "S", "W", "E"].each do |dir|
        np = Point.new(cur.pos.x + compassXOffset(dir),
                       cur.pos.y + compassYOffset(dir))
        if visited.fetch(np, false)
          next
        end
        visited[np] = true
        search << Search.new(np, cur.steps + 1,
                             cur.ic.cloneWithInput(compassToInput(dir)))
      end
    elsif res == 2
      ship.os = cur.pos
      ship.osic = cur.ic
      ship.steps = cur.steps
    end
  end
  return ship
end

def part2(ship)
  search = Deque(Search).new(100)
  start = ship.os
  ic = ship.osic
  if ic.nil?
    return
  end
  ["N", "S", "W", "E"].each do |dir|
    np = Point.new(start.x + compassXOffset(dir),
                   start.y + compassYOffset(dir))
    nic = ic.cloneWithInput(compassToInput(dir))
    search << Search.new(np, 1, nic)
  end
  visited = Hash(Point, Bool).new
  max = -2147483648
  while search.size() > 0
    cur = search.shift()
    cur.ic = tryDirection(cur.ic)
    res = cur.ic.outp.shift()
    if res == 0
      ship.wall[cur.pos] = true
    elsif res == 1
      if cur.steps > max
        max = cur.steps
      end
      ["N", "S", "W", "E"].each do |dir|
        np = Point.new(cur.pos.x + compassXOffset(dir),
                       cur.pos.y + compassYOffset(dir))
        if visited.fetch(np, false)
          next
        end
        visited[np] = true
        search << Search.new(np, cur.steps + 1,
                             cur.ic.cloneWithInput(compassToInput(dir)))
      end
    end
  end
  return max
end

ship = part1(prog);
print "Part1: ", ship.steps(), "\n"
print "Part2: ", part2(ship), "\n"
