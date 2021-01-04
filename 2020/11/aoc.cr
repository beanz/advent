require "aoc-lib.cr"

enum Seat
  None
  Empty
  Occupied
end

class Seats
  property cur
  property new
  property nc
  property w : Int32
  property h : Int32
  property changes : Int32

  def initialize(inp : Array(String))
    @h = inp.size
    @w = inp[0].size
    @changes = 0
    @cur = Array(Seat).new(@h*@w, Seat::None)
    @new = Array(Seat).new(@h*@w, Seat::None)
    inp.each_index do |y|
      inp[y].split("").each_index do |x|
        @cur[y*@w+x] = Seat::Empty if inp[y][x] == 'L'
      end
    end
    empty_neighbour_list = Array(Int32).new(0)
    @nc = Array(Array(Array(Int32))).new
    @nc << Array(Array(Int32)).new(@h*@w, empty_neighbour_list)
    @nc << Array(Array(Int32)).new(@h*@w, empty_neighbour_list)
    @cur.each_with_index do |s, i|
      next if s == Seat::None
      x = i % w
      y = i // w
      @nc[0][i] = neighbours(x, y, false)
      @nc[1][i] = neighbours(x, y, true)
    end
  end

  def neighbours(x, y, sight)
    nc = Array(Int32).new
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
      if s == Seat::Empty
        nc << (ox + @w * oy)
      end
    end
    return nc
  end

  def seat(x, y)
    if !(0 <= x < @w) || !(0 <= y < @h)
      return Seat::None
    end
    return @cur[y*@w+x]
  end

  def seat(i)
    return @cur[i]
  end

  def set(i, v)
    @new[i] = v
  end

  def swap()
    @cur, @new = @new, @cur
  end

  def occupied_count(i, nc_index)
    nc = 0
    @nc[nc_index][i].each do |ni|
      nc += 1 if seat(ni) == Seat::Occupied
    end
    return nc
  end

  def iter(group)
    @changes = 0
    nc_index = if group == 5 1 else 0 end
    oc = 0
    (0..@w*@h-1).each do |i|
      cur = seat(i)
      next if cur == Seat::None
      nc = occupied_count(i, nc_index)
      new = cur
      if cur == Seat::Empty && nc == 0
        @changes += 1
        new = Seat::Occupied
      elsif cur == Seat::Occupied && nc >= group
        @changes += 1
        new = Seat::Empty
      end
      set(i, new)
      if new == Seat::Occupied
        oc += 1
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
