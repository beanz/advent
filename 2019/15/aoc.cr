require "point.cr"
require "intcode.cr"

class Ship
  property wall
  property bb
  property os
  property osic : IntCode | ::Nil
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
  def initialize(@pos : Point, @steps : Int32, @ic : IntCode)
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

def tryDirection(ic : IntCode)
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
    nic = IntCode.new(prog.clone)
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
  max = Int32::MIN
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

prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64
ship = part1(prog);
print "Part1: ", ship.steps(), "\n"
print "Part2: ", part2(ship), "\n"
