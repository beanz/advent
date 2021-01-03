require "input.cr"
require "intcode.cr"

def runscript(prog : Array(Int64), script)
  ic = IntCode.new(prog, script)
  out = ic.runToHalt()
  s = ""
  out.each do |ch|
    if ch > 127
      return ch
    end
    print ch.unsafe_chr, "\n"
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

file = "input.txt"
if ARGV.size > 0
  file = ARGV[0]
end

inp = readints(file)
print "Part 1: ", part1(inp), "\n"

inp = readints(file)
print "Part 2: ", part2(inp), "\n"
