require "aoc-lib.cr"

struct Field
  property min1
  property max1
  property min2
  property max2

  def initialize(@min1 : Int32, @max1 : Int32, @min2 : Int32, @max2 : Int32)
  end
end

class Game
  property fields
  property our : Array(Int32)
  property valid : Array(Array(Int32))
  property invalid_count : Int32
  def initialize(inp)
    @fields = Hash(String, Field).new
    inp[0].split("\n").each do |l|
      ls = l.split(": ")
      name = ls[0]
      ints = ls[1].split(" or ").map { |r| r.split("-") }.flatten.map &.to_i32
      @fields[name] = Field.new(ints[0], ints[1], ints[2], ints[3])
    end
    @our = inp[1].split("\n")[1].split(",").map &.to_i32
    nearby = inp[2].split("\n")[1..]
    @valid = Array(Array(Int32)).new(nearby.size + 1)
    @valid << @our
    @invalid_count = 0
    nearby.each do |l|
      ticket = l.split(",").map &.to_i32
      validTicket = true
      ticket.each do |v|
        validField = false
        @fields.each_value do |f|
          if (f.min1 <= v <= f.max1) || (f.min2 <= v <= f.max2)
            validField = true
            break
          end
        end
        if !validField
          validTicket = false
          @invalid_count += v
        end
      end
      if validTicket
        @valid << ticket
      end
    end
  end
  def part1()
    return @invalid_count
  end
  def part2()
    possible = Hash(String,Set(Int32)).new
    @fields.each_key { |name| possible[name] = Set(Int32).new }
    target = @valid.size
    @our.each_index do |col|
      @fields.each do |name, f|
        valid = 0
        @valid.map { |t| t[col] }.each do |val|
          if (f.min1 <= val <= f.max1) || (f.min2 <= val <= f.max2)
            valid += 1
          end
        end
        if valid == target
          if debug()
            print "possible ", name, " at column ", col, "\n"
          end
          possible[name].add(col)
        end
      end
    end
    p = 1_i64
    while possible.size > 0
      progress = false
      possible.each do |name, cols|
        if cols.size == 1
          progress = true
          col = cols.first
          if debug()
            print name, " is definitely column ", col, "\n"
          end
          possible.delete(name)
          possible.each_value { |x| x.delete(col) }
          if name.starts_with?("departure") || istest?()
            p *= @our[col]
            if debug()
              print "product: ", p, "\n"
            end
          end
        end
      end
      if !progress
        raise "solver not making progress"
      end
    end
    return p
  end
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  g = Game.new(inputchunks(inp))
  p1 = g.part1()
  p2 = g.part2()
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
