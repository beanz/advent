require "aoc-lib.cr"
require "intcode.cr"

def run(prog, input)
  ic = IntCode.new(prog.clone)
  ic.inp.push(input)
  while ic.run() != 1
  end
  return ic.outp.join(",")
end

def part1(prog)
  return run(prog,1_i64)
end

def part2(prog)
  return run(prog,2_i64)
end

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

if ENV.has_key?("AoC_TEST")
  aeq(part1([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,
             99] of Int64),
      "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
  aeq(part1([1102,34915192,34915192,7,4,7,99,0] of Int64), "1219070632396864")
  aeq(part1([104,1125899906842624,99] of Int64), "1125899906842624")
  print "TESTS PASSED\n"
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  prog = inp.rstrip("\n").split(",").map &.to_i64
  p1 = part1(prog)
  p2 = part2(prog)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
