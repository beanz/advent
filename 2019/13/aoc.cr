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
  property ins : -> Int64
  property outp : Deque(Int64)
  property done : Bool
  property base : Int64

  def initialize(prog : Array(Int64), input : -> Int64)
    @prog = prog
    @ip = 0
    @ins = input
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
        @prog[inst.addr[0]] = ins.call()
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

def run(prog, infunc, outfunc)
  ic = IntComp.new(prog.clone, infunc)
  while ic.run() != 1
    if ic.outp.size() == 3
      outfunc.call(ic.outp.shift(), ic.outp.shift(), ic.outp.shift())
    end
  end
  return
end

def part1(prog)
  blocks = 0
  run(prog,
      ->() { return 0_i64 },
      ->(x : Int64, y : Int64, t : Int64) {
        if t == 2
          blocks += 1
        end
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
      ->(x : Int64, y : Int64, t : Int64) {
        if x == -1 && y == 0
          score = t
        elsif t == 3
          paddle = x
        elsif t == 4
          ball = x
        end
      })
  return score
end

prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64
print "Part1: ", part1(prog), "\n"

prog = File.read("input.txt").rstrip("\n").split(",").map &.to_i64
print "Part2: ", part2(prog), "\n"
