require "aoc-lib.cr"

MAX = 22
OFF = (MAX // 2).to_i8

class Game
  property init : Array(Bool)
  property cur : Array(Bool)
  property new : Array(Bool)
  property w : Int8
  property w2 : Int8

  def initialize(inp)
    @init = Array(Bool).new((MAX.to_i32)**4, false)
    @cur = Array(Bool).new((MAX.to_i32)**4, false)
    @new = Array(Bool).new((MAX.to_i32)**4, false)
    @w = inp.size.to_i8
    @w2 = @w//2;
    inp.each_with_index do |l, y|
      l.chars.each_with_index do |ch, x|
        if ch == '#'
          @init[index(OFF-@w2+x.to_i8, OFF-@w2+y.to_i8)] = true
        end
      end
    end
  end

  def index(x : Int8, y : Int8, z : Int8 = OFF, q : Int8 = OFF)
    return x.to_i32 + MAX*(y.to_i32 + MAX*(z.to_i32 + MAX*q.to_i32))
  end

  def set(x : Int8, y : Int8, z : Int8, q : Int8, v : Bool)
    @new[index(x,y,z,q)] = v
  end

  def get(x : Int8, y : Int8, z : Int8, q : Int8)
    return @cur[index(x,y,z,q)]
  end

  def neighbour_count(x : Int8, y : Int8, z : Int8, q : Int8, part2 : Bool)
    nc = 0
    qrange = part2 ? [-1, 0, 1] : [0]
    qrange.each do |oq|
      [-1, 0, 1].each do |oz|
        [-1, 0, 1].each do |oy|
          [-1, 0, 1].each do |ox|
            if (ox == oy == oz == oq == 0)
              next
            end
            if get(x+ox, y+oy, z+oz, q+oq)
              nc += 1
            end
          end
        end
      end
    end
    return nc
  end

  def pretty(iter : Int8, part2 : Bool)
    c = 0
    xystart : Int8 = OFF - (1 + @w2 + iter)
    xyend : Int8 = OFF + (2 + @w2 + iter)
    zstart : Int8 = OFF - (1 + iter)
    zend : Int8 = OFF + (1 + iter)
    qstart : Int8 = part2 ? zstart : OFF
    qend : Int8 = part2 ? zend : OFF

    q = qstart
    while q <= qend
      z = zstart
      while z <= zend
        print "z=", z-OFF-1+@w2, " q=", q-OFF-1+@w2, "\n"
        y = xystart
        while y <= xyend
          x = xystart
          while x <= xyend
            print get(x,y,z,q) ? "#" : "."
            x += 1
          end
          print "\n"
          y += 1
        end
        z += 1
      end
      q += 1
      print "\n"
    end
  end

  def iter(iter : Int8, part2 : Bool)
    c = 0
    xystart : Int8 = OFF - (1 + @w2 + iter)
    xyend : Int8 = OFF + (2 + @w2 + iter)
    zstart : Int8 = OFF - (1 + iter)
    zend : Int8 = OFF + (1 + iter)
    qstart : Int8 = part2 ? zstart : OFF
    qend : Int8 = part2 ? zend : OFF

    q = qstart
    while q <= qend
      z = zstart
      while z <= zend
        y = xystart
        while y <= xyend
          x = xystart
          while x <= xyend
            nc = neighbour_count(x, y, z, q, part2)
            cur = get(x, y, z, q)
            new = false
            if ( cur && nc == 2 ) || nc == 3
              new = true
            end
            set(x,y,z,q, new)
            c += 1 if new
            x += 1
          end
          y += 1
        end
        z += 1
      end
      q += 1
    end
    @cur, @new = @new, @cur
    if debug()
      print "Live: ", c, "\n"
      pretty(iter, part2)
    end
    return c
  end
  def calc(part2 : Bool)
    @cur = @init.clone
    @new.fill(false)
    r = 0
    (0..5).each do |i|
      r = iter(i.to_i8, part2)
    end
    return r
  end
  def part1()
    return calc(false)
  end
  def part2()
    return calc(true)
  end
end

inp = readinputlines()
g = Game.new(inp)

print "Part 1: ", g.part1(), "\n"
print "Part 2: ", g.part2(), "\n"
