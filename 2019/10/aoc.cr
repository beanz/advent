include Math

inp = File.read("input.txt").rstrip("\n").split("\n")

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

struct Asteroid
  property x, y
  def initialize(@x : Int32, @y : Int32)
  end
end

struct AsteroidPair
  property p1
  property p2
  def initialize(@p1 : Asteroid, @p2 : Asteroid)
  end
end

struct AsteroidAngle
  property p
  property angle
  def initialize(@p : Asteroid, @angle : Float64)
  end
end

class Game
  property best
  def initialize(inp)
    @asteroids = Hash(Asteroid, Bool).new
    @blockers = Hash(AsteroidPair, Int64).new
    @best = Asteroid.new(-1,-1)
    y = 0
    inp.each do |l|
      x = 0
      l.each_char do |c|
        if c == '#'
          @asteroids[Asteroid.new(x,y)] = true
        end
        if c == 'X'
          p = Asteroid.new(x,y)
          @asteroids[p] = true
          @best = p
        end
        x += 1
      end
      y += 1
    end
  end

  def num_blockers(a1, a2 : Asteroid)
    k = AsteroidPair.new(a1,a2)
    if @blockers.has_key?(k)
      return @blockers[k]
    end
    res = 0_i64
    dx = a2.x - a1.x
    dy = a2.y - a1.y
    if dx != 0 || dy != 0
      gcd = dx.gcd(dy)
      dx //= gcd
      dy //= gcd
    end
    p = Asteroid.new(a1.x + dx, a1.y + dy)
    while p != a2
      if @asteroids.has_key?(p)
        res += 1
      end
      p = Asteroid.new(p.x + dx, p.y + dy)
    end
    @blockers[k] = res
    k = AsteroidPair.new(a2,a1)
    @blockers[k] = res
    return res
  end

  def part1()
    max = -9223372036854775808_i64
    @asteroids.each_key do |a1|
      c = 0
      @asteroids.each_key do |a2|
        if a1 == a2
          next
        end
        if num_blockers(a1,a2) == 0
          c += 1
        end
      end
      if max < c
        max = c
        @best = a1
      end
    end
    return max
  end

  def angle(p)
    a = atan2((p.x-@best.x), (@best.y-p.y))
    while a < 0
      a += PI * 2
    end
    return a
  end

  def part2(num)
    angles = Array(AsteroidAngle).new
    @asteroids.each_key do |a|
      if @best == a
        next
      end
      angle = angle(a)
      angle += num_blockers(@best, a) * 2 * PI
      angles << AsteroidAngle.new(a, angle)
    end
    angles.sort_by! { |pd| pd.angle }
    p = angles[num-1].p
    return p.x*100 + p.y
  end
end

tg = Game.new([".#..#",".....","#####","....#","...##"] of String)
aeq(tg.num_blockers(Asteroid.new(3, 4), Asteroid.new(1, 0)), 1)
aeq(tg.num_blockers(Asteroid.new(4, 4), Asteroid.new(4, 2)), 1)
aeq(tg.num_blockers(Asteroid.new(3, 4), Asteroid.new(2, 2)), 0)
aeq(tg.num_blockers(Asteroid.new(3, 4), Asteroid.new(4, 0)), 0)
aeq(tg.num_blockers(Asteroid.new(4, 4), Asteroid.new(4, 0)), 2)
aeq(tg.num_blockers(Asteroid.new(4, 4), Asteroid.new(4, 3)), 0)

tg.best = Asteroid.new(2,2)
aeq(tg.angle(Asteroid.new(2, 0)), 0.0)                # n
aeq(tg.angle(Asteroid.new(4, 0)), 0.7853981633974483) # ne
aeq(tg.angle(Asteroid.new(4, 2)), 1.5707963267948966) # ee
aeq(tg.angle(Asteroid.new(4, 4)), 2.356194490192345)  # se
aeq(tg.angle(Asteroid.new(2, 4)), 3.141592653589793)  # s
aeq(tg.angle(Asteroid.new(0, 4)), 3.9269908169872414) # sw
aeq(tg.angle(Asteroid.new(0, 2)), 4.71238898038469)   # w
aeq(tg.angle(Asteroid.new(0, 0)), 5.497787143782138)  # nw

tg = Game.new(File.read("test2a.txt").rstrip("\n").split("\n"))
aeq(Asteroid.new(8,3), tg.best)
order = [801, 900, 901, 1000, 902, 1101, 1201, 1102, 1501]
order.each_index do |i|
  res = tg.part2(i + 1)
  aeq(res, order[i])
end

#aeq(part1([1,0,0,0,99]), 1)

g = Game.new(inp)

print "Part1: ", g.part1(), "\n"

print "Part2: ", g.part2(200), "\n"
