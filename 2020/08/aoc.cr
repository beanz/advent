require "aoc-lib.cr"

inp = readinputlines()

class HandHeld
  property ip : Int64
  property acc : Int64
  property prog : Array(Tuple(String, Int64))
  def initialize(inp : Array(String))
    @prog = inp.map {|x| ss = x.split(" "); {ss[0], ss[1].to_i64} }
    @ip = 0
    @acc = 0
  end

  def run()
    seen = Set(Int64).new
    @ip = 0
    @acc = 0
    while !seen.includes?(@ip) && @ip < @prog.size
      seen.add(@ip)
      inst = @prog[@ip]
      @ip += 1
      case inst[0]
      when "acc"
        @acc += inst[1]
      when "jmp"
        @ip += inst[1] - 1
      end
    end
    return @ip >= @prog.size
  end

  def part1()
    run()
    return @acc
  end

  def part2()
    (0 .. @prog.size).each do |i|
      inst = @prog[i]
      case inst[0]
      when "nop"
        @prog[i] = {"jmp", inst[1]}
        break if run()
        @prog[i] = {"nop", inst[1]}
      when "jmp"
        @prog[i] = {"nop", inst[1]}
        break if run()
        @prog[i] = {"jmp", inst[1]}
      end
    end
    return @acc
  end
end

hh = HandHeld.new(inp)

print "Part 1: ", hh.part1(), "\n"
print "Part 2: ", hh.part2(), "\n"
