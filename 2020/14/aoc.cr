require "aoc-lib.cr"

class MaskInst
  property m0 : Int64
  property m1 : Int64
  property mx : Int64
  def initialize(mask : String)
    @m0 = 0
    @m1 = 0
    @mx = 0
    mask.chars.each do |ch|
      @m0 <<= 1
      @m1 <<= 1
      @mx <<= 1
      case ch
      when '1'
        @m1 += 1
        @m0 += 1
      when 'X'
        @mx += 1
        @m0 += 1
      end
    end
  end
  def value(v)
    v |= @m1
    v &= @m0
  end
  def addrs(a)
    addrs = [ a | @m1 ]
    b = (1_i64 << 35)
    while b >= 1
      if (b & @mx) != 0
        (0..addrs.size-1).each do |i|
          a = addrs[i]
          if (a & b) != 0
            addrs << (a & (0xfffffffff ^ b))
          else
            addrs << (a | b)
          end
        end
      end
      b >>= 1
    end
    return addrs
  end
end

class MemInst
  property addr : Int64
  property value : Int64
  def initialize(l : String)
    ss = l[4..].split("] = ")
    @addr = ss[0].to_i64
    @value = ss[1].to_i64
  end
end

class Mem
  property mem
  property inst
  def initialize(inp)
    @mem = Hash(Int64, Int64).new
    @inst = Array(MemInst | MaskInst).new
    inp.each do |l|
      if l[1] == 'a'
        @inst << MaskInst.new(l[7..])
      else
        @inst << MemInst.new(l)
      end
    end
  end
  def part1()
    @mem.clear
    cur_mask = MaskInst.new("")
    @inst.each do |i|
      case i
      when MaskInst
        cur_mask = i
      when MemInst
        v = cur_mask.value(i.value)
        @mem[i.addr] = v
      end
    end
    return @mem.each_value.sum
  end

  def part2()
    @mem.clear
    cur_mask = MaskInst.new("")
    @inst.each do |i|
      case i
      when MaskInst
        cur_mask = i
      when MemInst
        cur_mask.addrs(i.addr).each do |a|
          @mem[a] = i.value
        end
      end
    end
    return @mem.each_value.sum
  end
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  mem = Mem.new(inputlines(inp))
  p1 = mem.part1()
  p2 = mem.part2()
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
