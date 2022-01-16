require "aoc-lib.cr"
require "intcode.cr"

def runscript(prog : Array(Int64), script)
  ic = IntCode.new(prog, script)
  out = ic.runToHalt()
  s = ""
  out.each do |ch|
    if ch > 127
      return ch
    end
    #print ch.unsafe_chr, "\n"
    s += ch.unsafe_chr
  end
  print s
  return -1
end

def part1(prog : Array(Int64))
  # (!C && D) || !A
  return runscript(prog, "NOT C J\nAND D J\nNOT A T\nOR T J\nWALK\n")
end

def part2(prog)
  # (!A || ( (!B || !C) && H ) ) && D
  return  runscript(prog,
     "NOT B T\nNOT C J\nOR J T\nAND H T\nNOT A J\nOR T J\nAND D J\nRUN\n");
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
