require "aoc-lib.cr"
require "point.cr"

struct Portal
  property exit : Point
  property name : String
  property level : Int32
  def initialize(@exit : Point, @name : String, @level : Int32)
  end
end

struct Search
  property pos : Point
  property steps : Int32
  property level : Int32
  property path : String
  def initialize(@pos : Point, @steps : Int32, @level : Int32, @path : String)
  end
  def vkey
    return "%d,%d_%d" % [ @pos.x, @pos.y, @level ]
  end
end

class Donut
  property m
  property p
  property bb
  property start
  property exit
  def initialize(lines : Array(String))
    @walls = Hash(Point, Bool).new
    @portals = Hash(Point, Portal).new
    @bb = BoundingBox.new
    @start = Point.new(-1,-1)
    @exit = Point.new(-1,-1)
    @bb.add(Point.new(0,0))
    @bb.add(Point.new(lines[0].size()-1, lines.size()-1))
    rp = Hash(String, Point).new
    isPortal = ->(x : Int32, y : Int32) {
      return 'A' <= lines[y][x] && lines[y][x] <= 'Z'
    }
    addPortal = ->(p : Point, bx : Int32, by : Int32,
                   ch1 : Char, ch2 : Char) {
      name = ch1.to_s + ch2.to_s
      @walls[Point.new(bx,by)] = true
      if (name == "AA")
        @start = p
        return
      end
      if (name == "ZZ")
        @exit = p
        return
      end
      level = 1
      if p.y == @bb.min.y+2 || p.y == @bb.max.y-2 || p.x == @bb.min.x+2 || p.x == @bb.max.x-2
        level = -1
      else
      end
      if rp.has_key?(name)
        ex = rp[name]
        @portals[p] = Portal.new(ex, name, level)
        @portals[ex] = Portal.new(p, name, -1*level)
        rp.delete(name)
      else
        rp[name] = p
      end
    }
    (@bb.min.y .. @bb.max.y).each do |y|
      (@bb.min.x .. @bb.max.x).each do |x|
        p = Point.new(x,y)
        if lines[y][x] == '#'
          @walls[p] = true
        elsif lines[y][x] == '.'
          if isPortal.call(x,y-2) && isPortal.call(x, y-1)
            addPortal.call(p, x, y-1, lines[y-2][x], lines[y-1][x])
          elsif (isPortal.call(x, y+1) && isPortal.call(x, y+2))
            addPortal.call(p, x, y+1, lines[y+1][x], lines[y+2][x])
          elsif (isPortal.call(x-2, y) && isPortal.call(x-1, y))
            addPortal.call(p, x-1, y, lines[y][x-2], lines[y][x-1])
          elsif (isPortal.call(x+1, y) && isPortal.call(x+2, y))
            addPortal.call(p, x+1, y, lines[y][x+1], lines[y][x+2])
          end
        end
      end
    end
    if rp.size != 0
      print "some portals not connected\n"
      exit
    end
  end
  def string()
    s = ""
    (@bb.min.y .. @bb.max.y).each do |y|
      (@bb.min.x .. @bb.max.x).each do |x|
        p = Point.new(x, y)
        if @start == p
          s += "S"
        elsif @exit == p
          s += "E"
        elsif @portals.has_key?(p)
          s += "~"
        elsif @walls.has_key?(p)
          s += "#"
        else
          s += "."
        end
      end
      s += "\n"
    end
    return s
  end
  def search(recurse : Bool)
    search = Deque(Search).new(100)
    search << Search.new(@start, 0, 0, "")
    visited = Hash(String,Bool).new
    while search.size() > 0
      cur = search.shift()
      if @walls.has_key?(cur.pos)
        next
      end
      vkey = cur.vkey()
      if visited.has_key?(vkey)
        next
      end
      visited[vkey] = true
      if cur.level == 0 && cur.pos.x == @exit.x && cur.pos.y == @exit.y
        return cur.steps
      end
      if @portals.has_key?(cur.pos)
        portal = @portals[cur.pos]
        nlevel = cur.level
        if recurse
          nlevel += portal.level
        end
        if nlevel >= 0
          npath = if cur.path.size() > 0
                    cur.path + " "
                  else
                    ""
                  end + portal.name
          search << Search.new(portal.exit, cur.steps+1, nlevel, npath)
        end
      end
      cur.pos.neighbours().each do |np|
        search << Search.new(np, cur.steps+1, cur.level, cur.path)
      end
    end
    return -1
  end
  def part1()
    return search(false)
  end
  def part2()
    return search(true)
  end
end

def readlines(file)
  File.read(file).rstrip("\n").split("\n")
end

if ENV.has_key?("AoC_TEST")
  aeq(Donut.new(readlines("test1a.txt")).part1(), 23)
  aeq(Donut.new(readlines("test1b.txt")).part1(), 58)
  aeq(Donut.new(readlines("input.txt")).part1(), 482)

  aeq(Donut.new(readlines("test1a.txt")).part2(), 26)
  aeq(Donut.new(readlines("test2a.txt")).part2(), 396)
  aeq(Donut.new(readlines("input.txt")).part2(), 5912)
  print "TESTS PASSED\n"
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  donut = Donut.new(inputlines(inp))
  p1 = donut.part1()
  p2 = donut.part2()
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
