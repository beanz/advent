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
  property prog : Array(Int64)
  property inp : Deque(Int64)
  property outp : Deque(Int64)
  property done : Bool
  property base : Int64
  property name : String
  property debug : Bool

  def initialize(prog : Array(Int64))
    @prog = prog.clone()
    @ip = 0
    @inp = Deque(Int64).new(5)
    @outp = Deque(Int64).new(5)
    @done = false
    @base = 0
    @name = "IC"
    @debug = false
  end

  def initialize(prog : Array(Int64), input : Int64)
    @prog = prog.clone()
    @ip = 0
    @inp = Deque(Int64).new(5)
    @outp = Deque(Int64).new(5)
    @done = false
    @base = 0
    @inp << input
    @name = input.to_s
    @debug = false
  end

  def initialize(prog : Array(Int64), input : String)
    @prog = prog.clone()
    @ip = 0
    @inp = Deque(Int64).new(5)
    @outp = Deque(Int64).new(5)
    @done = false
    @base = 0
    input.each_byte do |ch|
      @inp << ch.to_i64
    end
    @name = "IC"
    @debug = false
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

  def hexdump()
    return String.build do |str|
      0.step(to: @prog.size()-1, by: 8) do |i|
        str << sprintf("%s %08d: ", @name, i)
        (0..7).each do |j|
          addr = i+j
          if addr >= @prog.size()
            break
          end
          str << sprintf("%6d ", @prog[addr])
        end
        str << "\n"
      end
    end
  end

  def run()
    while @ip < @prog.size()
      if @debug
        #print(hexdump());
        printf("%s ip=%d %d,%d,%d,%d\n", @name, @ip,
               sprog(@ip+0), sprog(@ip+1), sprog(@ip+2), sprog(@ip+3))
      end
      inst = parseInst()
      case inst.op
      when 1
        if @debug
          printf("%s add %d + %d = %d => %d\n",
                 @name,
                 inst.param[0], inst.param[1],
                 inst.param[0] + inst.param[1],
                 inst.addr[2])
        end
        @prog[inst.addr[2]] = inst.param[0] + inst.param[1]
      when 2
        if @debug
          printf("%s mul %d * %d = %d => %d\n",
                 @name,
                 inst.param[0], inst.param[1],
                 inst.param[0] * inst.param[1],
                 inst.addr[2])
        end
        @prog[inst.addr[2]] = inst.param[0] * inst.param[1]
      when 3
        if @inp.size() == 0
          @ip -= opArity(inst.op)+1
          return 2
        else
          @prog[inst.addr[0]] = @inp.shift()
          if @debug
            printf("%s read %d => %d\n",
                   @name, @prog[inst.addr[0]], inst.addr[0])
          end
          #print "< ", @prog[inst.addr[0]], "\n";
        end
      when 4
        @outp.push(inst.param[0])
        if @debug
          printf("%s write %d => output\n", @name, inst.param[0])
        end
        #print "> ", inst.param[0], "\n";
        return 0
      when 5
        if @debug
          printf("%s jnz %d to %d\n", @name, inst.param[0], inst.param[1])
        end
        if inst.param[0] != 0
          @ip = inst.param[1]
        end
      when 6
        if @debug
          printf("%s jz %d to %d\n", @name, inst.param[0], inst.param[1])
        end
        if inst.param[0] == 0
          @ip = inst.param[1]
        end
      when 7
        if @debug
          printf("%s lt %d < %d => %d\n", @name,
                 inst.param[0], inst.param[1], inst.addr[2])
        end
        if inst.param[0] < inst.param[1]
          @prog[inst.addr[2]] = 1
        else
          @prog[inst.addr[2]] = 0
        end
      when 8
        if @debug
          printf("%s eq %d == %d => %d\n", @name,
                 inst.param[0], inst.param[1], inst.addr[2])
        end
        if inst.param[0] == inst.param[1]
          @prog[inst.addr[2]] = 1
        else
          @prog[inst.addr[2]] = 0
        end
      when 9
        @base += inst.param[0]
        if @debug
          printf("%s base += %d == %d\n", @name, inst.param[0], @base)
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
  def runToHalt()
    while !@done
      run()
    end
    return @outp
  end

  def nextOut()
    while run() != 1
      if @outp.size() == 1
        return @outp.pop()
      end
    end
    return -99
  end

  def runWithCallbacks(infn : -> Int64, outfn : Deque(Int64) -> , outn : Int64)
    while ! @done
      rc = run()
      case rc
      when 0
        if @outp.size() == outn
          o = Deque(Int64).new(outn)
          (1..outn).each do |i|
            o.push(@outp.shift)
          end
          outfn.call(o)
        end
      when 1
        return true
      when 2
        @inp << infn.call()
      else
        print "IntCode error"
        return false
      end
    end
  end
  def addInput(s : String)
    s.each_byte do |c|
      @inp << c.to_i64
    end
  end
end
