prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

def part1(prog)
  ip = 0
  l = prog.size()
  while ip < l
    op = prog[ip]
    ip += 1
    case op
    when 1
      if ip+2 >= l
        return -1
      end
      i1 = prog[ip]
      ip += 1
      i2 = prog[ip]
      ip += 1
      o = prog[ip]
      ip += 1
      prog[o] = prog[i1] + prog[i2]
    when 2
      if ip+2 >= l
        return -2
      end
      i1 = prog[ip]
      ip += 1
      i2 = prog[ip]
      ip += 1
      o = prog[ip]
      ip += 1
      prog[o] = prog[i1] * prog[i2]
    when 99
      return prog[0]
    else
      return -3
    end
  end
  return -4
end

def part2(prog_c)
  (0..9999).each do |input|
    prog = prog_c.clone
    prog[1] = (input / 100).to_i64
    prog[2] = (input % 100).to_i64
    res = part1(prog)
    if res == 19690720
      return input
    end
  end
  return -1
end
orig_prog = prog.clone

aeq(part1([1,0,0,0,99]), 2)
aeq(part1([1,1,1,4,99,5,6,0,99]), 30)

prog[1] = 12
prog[2] = 2
print "Part1: ", part1(prog), "\n"

print "Part2: ", part2(orig_prog), "\n"
