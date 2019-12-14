def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

struct Input
  property ch : String
  property num : Int64
  def initialize(@ch : String, @num : Int64)
  end
end

struct Reaction
  property num : Int64
  property inputs : Array(Input)
  def initialize(@num : Int64, @inputs : Array(Input))
  end
end

def quantity_chemical(s : String)
  num, ch = s.split(" ")
  return ch, num.to_i64
end

def ceil_div(a : Int64, b : Int64)
  return (a.to_f64 / b.to_f64).ceil().to_i64
end

class Factory
  property reactions
  property surplus
  property total
  def initialize(lines : Array(String))
    @reactions = Hash(String, Reaction).new
    lines.each do |line|
      in_str, out_str = line.split(" => ")
      out_name, out_num = quantity_chemical(out_str)
      inputs = Array(Input).new
      in_str.split(", ").each do |is|
        in_name, in_num = quantity_chemical(is)
        inputs << Input.new(in_name, in_num)
      end
      reactions[out_name] = Reaction.new(out_num, inputs)
    end
    @surplus = Hash(String, Int64).new
    @total = Hash(String, Int64).new
  end
  def reset()
    @surplus = Hash(String, Int64).new
    @total = Hash(String, Int64).new
  end
  def surplus(ch : String)
    if @surplus.has_key?(ch)
      return @surplus[ch]
    end
    return 0_i64
  end
  def use_surplus(ch : String, num : Int64)
    if ! @surplus.has_key?(ch)
      @surplus[ch] = 0
    end
    if @surplus[ch] < num
      raise "No surplus of " + num.to_s
    end
    @surplus[ch] -= num
    return @surplus[ch]
  end
  def produce(ch : String, num : Int64)
    if ! @total.has_key?(ch)
      @total[ch] = 0
    end
    @total[ch] += num
  end
  def requirements(ch : String, needed : Int64)
    if ch == "ORE"
      return
    end
    r = @reactions[ch]
    avail = surplus(ch)
    if avail > needed
      use_surplus(ch, needed)
      return
    end
    if avail > 0
      needed -= avail
      use_surplus(ch, avail)
    end
    required = ceil_div(needed, r.num)
    surplus = r.num * required - needed
    use_surplus(ch, -surplus)
    r.inputs.each do |inp|
      produce(inp.ch, inp.num * required)
      requirements(inp.ch, inp.num * required)
    end
  end
  def ore_for(num : Int64) Int64
    requirements("FUEL", num)
    return @total["ORE"]
  end
  def part1()
    return ore_for(1)
  end
  def part2()
    target = 1000000000000
    upper = 1_i64
    while ore_for(upper) < target
      reset()
      upper *= 2
    end
    lower = upper // 2
    while true
      mid = lower + (upper-lower) // 2
      if mid == lower
        break
      end
      reset()
      ore = ore_for(mid)
      if ore > target
        upper = mid
      else
        lower = mid
      end
    end
    return lower
  end
end

def readfile(file)
  File.read(file).rstrip("\n").split("\n")
end

file = "input.txt"
if ARGV.size > 0
  file = ARGV[0]
end

inp = readfile(file)

f = Factory.new(inp)

aeq(Factory.new(readfile("test1a.txt")).part1(), 31)
aeq(Factory.new(readfile("test1b.txt")).part1(), 165)
aeq(Factory.new(readfile("test1c.txt")).part1(), 13312)
aeq(Factory.new(readfile("test1d.txt")).part1(), 180697)
aeq(Factory.new(readfile("test1e.txt")).part1(), 2210736)
aeq(Factory.new(readfile("test1a.txt")).part2(), 34482758620)
aeq(Factory.new(readfile("test1b.txt")).part2(), 6323777403)
aeq(Factory.new(readfile("test1c.txt")).part2(), 82892753)
aeq(Factory.new(readfile("test1d.txt")).part2(), 5586022)
aeq(Factory.new(readfile("test1e.txt")).part2(), 460664)

print "Part1: ", f.part1(), "\n"
print "Part2: ", f.part2(), "\n"
