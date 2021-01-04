require "aoc-lib.cr"

enum Seat
  None
  Empty
  Occupied
end

class Seats
  property cur
  property new
  property w : Int32
  property h : Int32
  property changes : Int32

  def initialize(inp : Array(String))
    @h = inp.size
    @w = inp[0].size
    @changes = 0
    @cur = Array(Seat).new(@w*@h, Seat::None)
    @new = Array(Seat).new(@w*@h, Seat::None)
    inp.each_index do |y|
      inp[y].split("").each_index do |x|
        @cur[(y*@w+x).to_i64] = Seat::Empty if inp[y][x] == 'L'
      end
    end
  end

  def seat(x, y)
    if !(0 <= x < @w) || !(0 <= y < @h)
      return Seat::None
    end
    return @cur[y*@w+(x%@w)]
  end

  def set(x, y, v)
    @new[y*@w+(x%@w)] = v
  end

  def swap()
    @cur, @new = @new, @cur
  end

  def neighbour_count(x, y, sight)
    nc = 0
    [[-1,-1],[0,-1],[1,-1],[-1,0],[1,0],[-1,1],[0,1],[1,1]].each do |o|
      ox = x+o[0]
      oy = y+o[1]
      s = Seat::None
      while 0 <= ox < @w && 0 <= oy < @h
        s = seat(ox, oy)
        if s != Seat::None || !sight
          break
        end
        ox += o[0]
        oy += o[1]
      end
      if s == Seat::Occupied
        nc += 1
      end
    end
    return nc
  end

  def iter(group)
    @changes = 0
    oc = 0
    (0..@h-1).each do |y|
      (0..@w-1).each do |x|
        cur = seat(x,y)
        next if cur == Seat::None
        nc = neighbour_count(x, y, group == 5)
        new = cur
        if cur == Seat::Empty && nc == 0
          @changes += 1
          new = Seat::Occupied
        elsif cur == Seat::Occupied && nc >= group
          @changes += 1
          new = Seat::Empty
        end
        set(x, y, new)
        if new == Seat::Occupied
          oc += 1
        end
      end
    end
    swap()
    if debug()
      puts "changes=#{@changes} oc=#{oc}"
    end
    return oc
  end

  def run(group)
    oc = 0
    @changes = 1
    while @changes > 0
      oc = iter(group)
    end
    return oc
  end
end


inp = readinputlines()

seats = Seats.new(inp)
print "Part 1: ", seats.run(4), "\n"

seats = Seats.new(inp)
print "Part 2: ", seats.run(5), "\n"
