require "aoc-lib.cr"
require "intcode.cr"

def part1(prog : Array(Int64))
  ic = Array(IntCode).new(50)
  (0..49).each do |i|
    ic << IntCode.new(prog, i.to_i64)
  end
  while true
    (0..49).each do |i|
      rc = ic[i].run()
      if rc == 0
        if ic[i].outp.size() >= 3
          addr = ic[i].outp.shift()
          x = ic[i].outp.shift()
          y = ic[i].outp.shift()
          if addr == 255
            return y
          elsif addr < 50
            ic[addr].inp << x
            ic[addr].inp << y
            #print "sent ", addr, " < ", x, ",", y, "\n"
          end
        end
      elsif rc ==2
        ic[i].inp << -1
      end
    end
  end
end

def part2(prog)
  ic = Array(IntCode).new(50)
  (0..49).each do |i|
    ic << IntCode.new(prog, i.to_i64)
  end
  natX : Int64 = 0
  natY : Int64 = 0
  lastY : Int64 = -1
  while true
    idle = 0
    (0..49).each do |i|
      rc = ic[i].run()
      if rc == 0
        if ic[i].outp.size() >= 3
          addr = ic[i].outp.shift()
          x = ic[i].outp.shift()
          y = ic[i].outp.shift()
          if addr == 255
            natX = x
            natY = y
          elsif addr < 50
            ic[addr].inp << x
            ic[addr].inp << y
            #print "sent ", addr, " < ", x, ",", y, "\n"
          end
        end
      elsif rc ==2
        ic[i].inp << -1
        idle += 1
      end
    end
    if idle == 50
      #print "nat 0 < ", natX, ",", natY, "\n"
      if lastY == natY
        return natY
      end
      lastY = natY
      ic[0].inp << natX
      ic[0].inp << natY
    end
  end
end

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
