require "aoc-lib.cr"

class Cup
  property val : UInt32
  property cw : Cup | Nil
  property ccw : Cup | Nil
  def initialize(@val)
    @cw = self
    @ccw = self
  end
  def cw_cup()
    c = @cw
    if !c.is_a?(Cup)
      raise "corrupt cup ring"
    end
    return c
  end
  def ccw_cup()
    c = @ccw
    if !c.is_a?(Cup)
      raise "corrupt cup ring"
    end
    return c
  end

  def insert_after(new : Cup)
    # cur<->after    new<->...<->last => cur<->new<->...<->last<->after
    after = cw_cup
    last = new.ccw_cup
    @cw = new
    new.ccw = self
    last.cw = after
    after.ccw = last
  end
  def pick()
    p1 = cw_cup
    p2 = p1.cw_cup
    p3 = p2.cw_cup
    n = p3.cw_cup
    # fix self
    @cw = n
    n.ccw = self
    # fix picked ring
    p1.ccw = p3
    p3.cw = p1
    return p1
  end
  def to_s(io)
    cup = cw_cup
    io << @val
    while cup.val != @val
      io << cup.val
      cup = cup.cw_cup
    end
    io
  end
  def back_string()
    cup = ccw_cup
    s = @val.to_s
    while cup.val != @val
      s += cup.val.to_s
      cup = cup.ccw_cup
    end
    return s
  end
  def part1_string()
    cup = cw_cup
    s = ""
    while cup.val != @val
      s += cup.val.to_s
      cup = cup.cw_cup
    end
    return s
  end
end

class Game
  property init : Array(UInt32)
  def initialize(inp)
    @init = inp.chars.map &.to_u32
  end
  def play(moves : UInt32, max : UInt32)
    cups = Array(Cup).new(max + 1) { |i| Cup.new(i.to_u32) }
    last : Cup | Nil = nil
    @init.each do |v|
      n = cups[v]
      if last.is_a?(Cup)
        last.insert_after(n)
      end
      last = n
    end
    cur = cups[@init.first]
    if !last.is_a?(Cup)
      raise "Initialization failed"
    end
    (@init.size+1..max).each do |v|
      last.insert_after(cups[v])
      last = cups[v]
    end
    if !cur.is_a?(Cup)
      raise "corrupted cup ring"
    end
    (1..moves).each do |move|
      pick = cur.pick()
      dst = cur.val
      v1 = pick.val
      p2 = pick.cw_cup
      v2 = p2.val
      p3 = p2.cw_cup
      v3 = p3.val
      while true
        dst -= 1
        if dst == 0
          dst = max
        end
        if dst != v1 && dst != v2 && dst != v3
          break
        end
      end
      dcup = cups[dst]
      dcup.insert_after(pick)
      cur = cur.cw_cup
    end
    return cups[1]
  end
  def part1(moves : UInt32)
    cup1 = play(moves, 9)
    return cup1.part1_string
  end
  def part2()
    cup1 = play(10000000, 1000000)
    return cup1.cw_cup.val.to_u64 * cup1.cw_cup.cw_cup.val
  end
end

inp = readinputlines()[0]
g = Game.new(inp)

print "Part 1: ", g.part1(100), "\n"
print "Part 2: ", g.part2(), "\n"
