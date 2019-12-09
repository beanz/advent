prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64

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
  r = [0,3,3,1,1,2,2,3,3,1][op]
  return r
end

class IntComp
  property ip : Int64
  property inp : Deque(Int64)
  property outp : Deque(Int64)
  property done : Bool
  property base : Int64

  def initialize(prog : Array(Int64))
    @prog = prog
    @ip = 0
    @inp = Deque(Int64).new(5)
    @outp = Deque(Int64).new(5)
    @done = false
    @base = 0
  end

  def sprog(i)
    while @prog.size() <= i
      @prog << 0
    end
    return @prog[i]
  end

  def parseInst()
    rawop = @prog[@ip]
    @ip += 1
    inst = Inst.new(rawop%100)
    mode : Array(Int64) =
      [(rawop // 100) % 10, (rawop // 1000) % 10, (rawop // 10000) % 10]
    (0..opArity(inst.op)-1).each do |i|
      case mode[i]
      when 1
        inst.param << @prog[@ip]
        inst.addr << -99
      when 2
        inst.param << sprog(@base+@prog[@ip])
        inst.addr << @base+@prog[@ip]
      else
        inst.param << sprog(@prog[@ip])
        inst.addr << @prog[@ip]
      end
      @ip += 1
    end
    return inst
  end

  def run()
    while @ip < @prog.size()
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
      when 4
        @outp.push(inst.param[0])
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
      when 9
        @base += inst.param[0]
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

def run(prog, input)
  ic = IntComp.new(prog.clone)
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

print "Part1: ", part1(prog), "\n"
print "Part2: ", part2(prog), "\n"
