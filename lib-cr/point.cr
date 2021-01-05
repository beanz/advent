struct Point
  property x, y
  def initialize(@x : Int32, @y : Int32)
  end

  def initialize(comp : Char)
    case comp
    when 'N'
      @x, @y = 0, -1
    when 'S'
      @x, @y = 0, 1
    when 'E'
      @x, @y = 1, 0
    when 'W'
      @x, @y = -1, 0
    else
      raise "Invalid direction: "+comp
    end
  end

  def move(dir : Direction, steps = 1)
    @x += dir.x * steps
    @y += dir.y * steps
  end

  def move(p : Point, steps = 1)
    @x += p.x * steps
    @y += p.y * steps
  end

  def move_x(x : Int32)
    @x += x
  end

  def move_y(y : Int32)
    @y += y
  end

  def cw()
    @x, @y = -1 * @y, @x
  end

  def ccw()
    @x, @y = @y, -1 * @x
  end

  def manhattan()
    return @x.abs + @y.abs
  end

  def in(dir : Direction)
    return Point.new(x + dir.x, y + dir.y)
  end

  def neighbours()
    return [
      Point.new(x, y-1),
      Point.new(x-1, y),
      Point.new(x+1, y),
      Point.new(x, y+1)
    ]
  end
end

struct BoundingBox
  property min, max
  def initialize()
    @min = Point.new(Int32::MAX, Int32::MAX)
    @max = Point.new(Int32::MIN, Int32::MIN)
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
