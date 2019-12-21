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

class IntCode
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

  def initialize(prog : Array(Int64), input : Int64)
    @prog = prog
    @ip = 0
    @inp = Deque(Int64).new(5)
    @outp = Deque(Int64).new(5)
    @done = false
    @base = 0
    @inp << input
  end

  def initialize(prog : Array(Int64), input : String)
    @prog = prog
    @ip = 0
    @inp = Deque(Int64).new(5)
    @outp = Deque(Int64).new(5)
    @done = false
    @base = 0
    input.each_byte do |ch|
      @inp << ch.to_i64
    end
  end

  def cloneWithInput(input : Int64)
    ic = IntCode.new(@prog.clone)
    ic.inp << input
    ic.ip = @ip
    ic.base = @base
    return ic
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
  def runToHalt()
    while !@done
      run()
    end
    return @outp
  end
end
