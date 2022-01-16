require "aoc-lib.cr"
require "intcode.cr"

def tryPhase(prog, phase)
  u = Array(IntCode).new
  phase.each do |p|
    ic = IntCode.new(prog.clone)
    ic.inp.push(p)
    u << ic
  end
  done = 0
  last = 0_i64
  outv = 0_i64
  first = true
  while done < phase.size()
    done = 0
    (0..phase.size()-1).each do |i|
      if u[i].done
        done += 1
      else
        if !first
          u[i].inp.push(outv)
        end
        first = false
        rc = u[i].run()
        if u[i].outp.size() != 0
          outv = u[i].outp.shift()
          last = outv
          #print "ran unit ", i, " and received ", outv, " (", rc, ")\n"
        end
        if rc == 1 || rc == -1
          done += 1
        end
      end
    end
  end
  return last
end

def run(prog, minPhase : Int64)
  phase = [minPhase, minPhase+1, minPhase+2, minPhase+3, minPhase+4]
  max = -9223372036854775808_i64
  phase.each_permutation do |p|
    thrust = tryPhase(prog, p)
    if max < thrust
      max = thrust
    end
  end
  return max
end

def part1(prog)
    return run(prog, 0)
end
def part2(prog)
    return run(prog, 5)
end

aeq(part1([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0] of Int64), 43210)
aeq(part1([3,23,3,24,1002,24,10,24,1002,23,-1,23,
           101,5,23,23,1,24,23,23,4,23,99,0,0] of Int64), 54321)
aeq(part1([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
           1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0] of Int64), 65210)
aeq(part2([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
           27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5] of Int64), 139629729)
aeq(part2([3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
           -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
           53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10] of Int64), 18216)

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
