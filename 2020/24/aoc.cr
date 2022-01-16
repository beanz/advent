require "aoc-lib.cr"

class Hex
  property q : Int16
  property r : Int16
  def initialize(@q : Int16, @r : Int16)
  end
  def initialize(moves : String)
    @q = 0
    @r = 0
    i = 0
    while i < moves.size
      case moves[i]
      when 'e'
        @q += 1
        i += 1
      when 'w'
        @q -= 1
        i += 1
      when 's'
        case moves[i+1]
        when 'e'
          @r -= 1
          i += 2
        when 'w'
          @q -= 1
          @r -= 1
          i += 2
        end
      when 'n'
        case moves[i+1]
        when 'e'
          @q += 1
          @r += 1
          i += 2
        when 'w'
          @r += 1
          i += 2
        end
      end
    end
  end
  def to_s(io)
    io << "H" << @q << "," << @r;
    io
  end
  def ==(other)
    @q == other.q && @r == other.r
  end
  def hash(hasher)
    i = q.to_i32 << 16 + r
    hasher = i.hash(hasher)
  end
  def neighbours()
    [{1, 0}, {0,-1}, {-1,-1}, {-1, 0}, {0, 1}, {1,1}].map do |o|
      Hex.new(@q + o[0], @r + o[1])
    end
  end
end

class Game
  property init
  def initialize(inp)
    @init = Set(Hex).new(inp.size)
    inp.each do |l|
      h = Hex.new(l)
      if @init.includes?(h)
        @init.delete(h)
      else
        @init << h
      end
    end
  end
  def part1()
    return @init.size
  end
  def part2()
    cur = @init.dup
    check = cur.reduce(Set(Hex).new(2000)) do |acc, h|
      acc << h
      h.neighbours.each { |nb| acc << nb }
      acc
    end
    100.times do |day|
      check_next = Set(Hex).new(2000)
      new = check.select do |h|
        nbs = h.neighbours
        c = nbs.count { |nb| cur.includes?(nb) }
        if (cur.includes?(h) && !(c == 0 || c > 2)) || (!cur.includes?(h) && c == 2)
          check_next << h
          nbs.each { |nb| check_next << nb }
          true
        else
          false
        end
      end
      cur = new
      check = check_next
      print "Day ", day+1, ": ", cur.size, "\n" if debug()
    end
    return cur.size
  end
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  g = Game.new(inputlines(inp))
  p1 = g.part1()
  p2 = g.part2()
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
