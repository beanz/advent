prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

class Inst
  getter param
  getter addr
  property op : Int64

  def initialize(op : Int64)
    @op = op
    @param = Array(Int64).new
    @addr = Array(Int64).new
  end
end

def opArity(op : Int64)
  if op == 99
    return 0
  end
  r = [0,3,3,1,1,2,2,3,3][op]
  return r
end

class IntComp
  property ip : Int64
  property inp : Deque(Int64)
  property outp : Deque(Int64)
  property done : Bool

  def initialize(prog : Array(Int64))
    @prog = prog
    @ip = 0
    @inp = Deque(Int64).new(5)
    @outp = Deque(Int64).new(5)
    @done = false
  end

  def parseInst()
    rawop = @prog[@ip]
    @ip += 1
    inst = Inst.new(rawop%100)
    immediate : Array(Bool) =
      [(rawop // 100) % 10 == 1,
       (rawop // 1000) % 10 == 1,
       (rawop // 10000) % 10 == 1]
    (0..opArity(inst.op)-1).each do |i|
      if immediate[i]
        inst.param << @prog[@ip]
        inst.addr << -99
      else
        inst.param << @prog[@prog[@ip]]
        inst.addr << @prog[@ip]
      end
      @ip += 1
    end
    return inst
  end

  def run()
    while @ip < @prog.size()
      #print "ip=", @ip, " ", @prog[@ip..@ip+10], "\n"
      inst = parseInst()
      case inst.op
      when 1
        @prog[inst.addr[2]] = inst.param[0] + inst.param[1]
      when 2
        @prog[inst.addr[2]] = inst.param[0] * inst.param[1]
      when 3
        if @inp.size() == 0
          @prog[inst.addr[0]] = 0
        else
          @prog[inst.addr[0]] = @inp.shift()
        end
        #print "3: ", @prog[inst.addr[0]], " >> ", inst.addr[0], "\n"
      when 4
        @outp.push(inst.param[0])
        #print "4: ", inst.param[0], " >> output\n"
        return 0
      when 5
        if inst.param[0] != 0
          @ip = inst.param[1]
        end
      when 6
        if inst.param[0] == 0
          @ip = inst.param[1]
        end
      when 7
        if inst.param[0] < inst.param[1]
          @prog[inst.addr[2]] = 1
        else
          @prog[inst.addr[2]] = 0
        end
      when 8
        if inst.param[0] == inst.param[1]
          @prog[inst.addr[2]] = 1
        else
          @prog[inst.addr[2]] = 0
        end
      when 99
        @done = true
        return 1
      else
        @done = true
        return -1
      end
    end
    @done = true
    return -2
  end
end

def tryPhase(prog, phase)
  u = Array(IntComp).new
  phase.each do |p|
    ic = IntComp.new(prog.clone)
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

print "Part1: ", part1(prog), "\n"
print "Part2: ", part2(prog), "\n"