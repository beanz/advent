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

  def cloneWithInput(input : Int64)
    ic = IntComp.new(@prog.clone)
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

  def nextOut()
    while run() != 1
      if @outp.size() == 1
        return @outp.pop()
      end
    end
    return -99
  end
end

class Beam
  property size : Int64
  property ratio1 : Int64
  property ratio2 : Int64
  property divisor : Int64
  def initialize(prog : Array(Int64))
    @prog = prog
    @size = 100_i64 - 1
    @divisor = 0
    @ratio1 = 1
    @ratio2 = 2
  end

  def inBeam(x : Int64, y : Int64)
    ic = IntComp.new(@prog.clone)
    ic.inp << x
    ic.inp << y
    return ic.nextOut() == 1
  end

  def part1()
    count = 0
    first = -1_i64
    last = -1_i64
    (0_i64 .. 49).each do |y|
      first = -1_i64
      last = -1_i64
      (0_i64 .. 49).each do |x|
        if inBeam(x, y)
          if first == -1
            first = x
          end
          last = x
          count += 1
        end
      end
    end
    @ratio1 = first
    @ratio2 = last
    @divisor = 49
    return count
  end

  def squareFits(x, y)
    return inBeam(x,y) && inBeam(x+@size, y) && inBeam(x, y+@size)
  end
  def squareFitsY(y)
    min = (y * @ratio1 // @divisor)
    max = (y * @ratio2 // @divisor)
    (min .. max).each do |x|
      if squareFits(x, y)
        return x
      end
    end
    return 0
  end

  def part2()
    upper = 1_i64
    while (squareFitsY(upper) == 0)
      upper *= 2
    end
    lower = upper // 2
    while (true)
      mid = (lower+upper) // 2
      if mid == lower
        break
      end
      if squareFitsY(mid) > 0
        upper = mid
      else
        lower = mid
      end
    end
    (lower .. lower+5).each do |y|
      x = squareFitsY(y)
      if x > 0
        return x*10000 + y
      end
    end
    return -1
  end
end

beam = Beam.new(prog);
print "Part1: ", beam.part1(), "\n"
print "Part2: ", beam.part2(), "\n"
