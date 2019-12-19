struct Point
  property x, y
  def initialize(@x : Int32, @y : Int32)
  end
  def in(dir : Direction)
    return Point.new(x + dir.x, y + dir.y)
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

struct Direction
  property x, y
  def initialize(@x : Int32, @y : Int32)
  end

  def cw()
    if @x == 0 && @y == -1
      return Direction.new(1,0)
    elsif @x == 1 && @y == 0
      return Direction.new(0,1)
    elsif @x == 0 && @y == 1
      return Direction.new(-1,0)
    else # @x == -1 && @y == 0
      return Direction.new(0,-1)
    end
  end

  def ccw()
    if @x == 0 && @y == -1
      return Direction.new(-1,0)
    elsif @x == 1 && @y == 0
      return Direction.new(0,-1)
    elsif @x == 0 && @y == 1
      return Direction.new(1,0)
    else # @x == -1 && @y == 0
      return Direction.new(0,1)
    end
  end
end
