require "aoc-lib.cr"
require "intcode.cr"

def part1(prog)
  c = IntCode.new(prog.clone, 1)
  c.runToHalt()
  return c.outp[-1]
end

def part2(prog, input : Int64)
  c = IntCode.new(prog.clone, input)
  c.run()
  return c.outp[0]
end

aeq(opArity(1), 3)
aeq(opArity(2), 3)
aeq(opArity(3), 1)
aeq(opArity(4), 1)
aeq(opArity(5), 2)
aeq(opArity(6), 2)
aeq(opArity(7), 3)
aeq(opArity(8), 3)
aeq(opArity(99), 0)

aeq(part2([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8] of Int64, 8), 1)
aeq(part2([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8] of Int64, 4), 0)
aeq(part2([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8] of Int64, 7), 1)
aeq(part2([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8] of Int64, 8), 0)
aeq(part2([3, 3, 1108, -1, 8, 3, 4, 3, 99] of Int64, 8), 1)
aeq(part2([3, 3, 1108, -1, 8, 3, 4, 3, 99] of Int64, 9), 0)
aeq(part2([3, 3, 1107, -1, 8, 3, 4, 3, 99] of Int64, 7), 1)
aeq(part2([3, 3, 1107, -1, 8, 3, 4, 3, 99] of Int64, 9), 0)
aeq(part2([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99,
          -1, 0, 1, 9] of Int64, 2), 1)
aeq(part2([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99,
          -1, 0, 1, 9] of Int64, 0), 0)
aeq(part2([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1] of Int64, 3),
       1)
aeq(part2([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1] of Int64, 0),
       0)
aeq(part2([3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
          20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20,
          1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
          1, 46, 98, 99] of Int64, 5), 999)
aeq(part2([3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
          20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20,
          1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
          1, 46, 98, 99] of Int64, 8), 1000)
aeq(part2([3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21,
          20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20,
          1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105,
          1, 46, 98, 99] of Int64, 9), 1001)

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  prog = inp.rstrip("\n").split(",").map &.to_i64
  p1 = part1(prog)
  p2 = part2(prog, 5)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
