require "aoc-lib.cr"

class Cup
  property cw : Int32
  property ccw : Int32
  def initialize(@cw, @ccw)
  end
end

class Cups
  property cups : Array(Cup)
  property init : Array(Int32)
  def initialize(inp, max)
    @init = inp.chars.map &.to_i32
    @cups = Array(Cup).new(max + 1) { |i| Cup.new(i, i) }
  end
  def to_s(io)
    @cups.each_with_index do |c, i|
      io << "c: " << i << " " << c.ccw << "<>" << c.cw << "\n"
    end
    io
  end
  def insert_after(cur : Int32, new : Int32)
    # cur<->after    new<->...<->last => cur<->new<->...<->last<->after
    after = @cups[cur].cw
    last = @cups[new].ccw
    @cups[cur].cw = new
    @cups[new].ccw = cur
    @cups[last].cw = after
    @cups[after].ccw = last
  end
  def pick(cur : Int32)
    p1 = @cups[cur].cw
    p2 = @cups[p1].cw
    p3 = @cups[p2].cw
    n = @cups[p3].cw
    # fix self
    @cups[cur].cw = n
    @cups[n].ccw = cur
    # fix picked ring
    @cups[p1].ccw = p3
    @cups[p3].cw = p1
    return p1
  end
  def str(cur : Int32)
    s = cur.to_s
    cup = @cups[cur].cw
    while cup != cur
      s += cup.to_s
      cup = @cups[cup].cw
    end
    return s
  end
  def rstr(cur : Int32)
    s = cur.to_s
    cup = @cups[cur].ccw
    while cup != cur
      s += cup.to_s
      cup = @cups[cup].ccw
    end
    return s
  end
  def part1_string(cur)
    cup = @cups[cur].cw
    s = ""
    while cup != cur
      s += cup.to_s
      cup = @cups[cup].cw
    end
    return s
  end
  def play(moves : Int32, max : Int32)
    cur = @init.first
    last = cur
    @init.skip(1).each do |v|
      insert_after(last, v)
      last = v
    end
    (@init.size+1..max).each do |v|
      insert_after(last, v)
      last = v
    end
    (1..moves).each do |move|
      p1 = pick(cur)
      dst = cur
      p2 = @cups[p1].cw
      p3 = @cups[p2].cw
      while true
        dst -= 1
        if dst == 0
          dst = max
        end
        if dst != p1 && dst != p2 && dst != p3
          break
        end
      end
      insert_after(dst, p1)
      cur = @cups[cur].cw
    end
  end
  def part1(moves : Int32)
    play(moves, 9)
    return part1_string(1)
  end
  def part2()
    play(10000000, 1000000)
    return @cups[1].cw.to_u64 * @cups[@cups[1].cw].cw
  end
end

inp = readinputlines()[0]

print "Part 1: ", Cups.new(inp, 10).part1(100), "\n"
print "Part 2: ", Cups.new(inp, 1000000).part2(), "\n"
