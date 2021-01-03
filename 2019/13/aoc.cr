require "intcode.cr"

def run(prog, infunc, outfunc)
  ic = IntCode.new(prog.clone)
  ic.runWithCallbacks(infunc, outfunc, 3)
  return
end

def part1(prog)
  blocks = 0
  run(prog,
      ->() { return 0_i64 },
      ->(o : Deque(Int64)) {
        x = o.shift
        y = o.shift
        t = o.shift
        if t == 2
          blocks += 1
        end
        return
      })
  return blocks
end

def part2(prog)
  paddle = 0
  ball = 0
  score = 0
  prog[0] = 2
  run(prog,
      ->() { # return (ball <=> paddle).as(Int64) didn't compile?
        if ball < paddle
          return -1_i64
        elsif ball > paddle
          return 1_i64
        end
        return 0_i64
      },
      ->(o : Deque(Int64)) {
        x = o.shift
        y = o.shift
        t = o.shift
        if x == -1 && y == 0
          score = t
        elsif t == 3
          paddle = x
        elsif t == 4
          ball = x
        end
        return
      })
  return score
end

prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64
print "Part1: ", part1(prog), "\n"

prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64
print "Part2: ", part2(prog), "\n"
