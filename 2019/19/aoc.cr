require "../lib/intcode.cr"

class Beam
  property size : Int64
  property ratio1 : Int64
  property ratio2 : Int64
  property divisor : Int64
  def initialize(prog : Array(Int64))
    @prog = prog
    @size = 100_i64 - 1
    @divisor = 0
    @ratio1 = 1
    @ratio2 = 2
  end

  def inBeam(x : Int64, y : Int64)
    ic = IntCode.new(@prog.clone)
    ic.inp << x
    ic.inp << y
    return ic.nextOut() == 1
  end

  def part1()
    count = 0
    first = -1_i64
    last = -1_i64
    (0_i64 .. 49).each do |y|
      first = -1_i64
      last = -1_i64
      (0_i64 .. 49).each do |x|
        if inBeam(x, y)
          if first == -1
            first = x
          end
          last = x
          count += 1
        end
      end
    end
    @ratio1 = first
    @ratio2 = last
    @divisor = 49
    return count
  end

  def squareFits(x, y)
    return inBeam(x,y) && inBeam(x+@size, y) && inBeam(x, y+@size)
  end
  def squareFitsY(y)
    min = (y * @ratio1 // @divisor)
    max = (y * @ratio2 // @divisor)
    (min .. max).each do |x|
      if squareFits(x, y)
        return x
      end
    end
    return 0
  end

  def part2()
    upper = 1_i64
    while (squareFitsY(upper) == 0)
      upper *= 2
    end
    lower = upper // 2
    while (true)
      mid = (lower+upper) // 2
      if mid == lower
        break
      end
      if squareFitsY(mid) > 0
        upper = mid
      else
        lower = mid
      end
    end
    (lower .. lower+5).each do |y|
      x = squareFitsY(y)
      if x > 0
        return x*10000 + y
      end
    end
    return -1
  end
end

prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64
beam = Beam.new(prog);
print "Part1: ", beam.part1(), "\n"
print "Part2: ", beam.part2(), "\n"
