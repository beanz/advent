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
  property outp : Array(Int64)

  def initialize(prog : Array(Int64))
    @prog = prog
    @ip = 0
    @outp = [] of Int64
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

  def run(input : Int64)
    @ip = 0
    l = @prog.size()
    while @ip < l
      #print "ip=", @ip, " ", @prog[@ip..@ip+10], "\n"
      inst = parseInst()
      case inst.op
      when 1
        @prog[inst.addr[2]] = inst.param[0] + inst.param[1]
      when 2
        @prog[inst.addr[2]] = inst.param[0] * inst.param[1]
      when 3
        @prog[inst.addr[0]] = input
      when 4
        @outp << inst.param[0]
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
        return true
      else
        return false
      end
    end
    return false
  end
end

def part1(prog)
  c = IntComp.new(prog.clone)
  c.run(1)
  return c.outp[-1]
end

def part2(prog, input : Int64)
  c = IntComp.new(prog.clone)
  c.run(input)
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

print "Part1: ", part1(prog), "\n"
print "Part2: ", part2(prog, 5), "\n"
