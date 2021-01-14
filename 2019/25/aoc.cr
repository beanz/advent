require "aoc-lib.cr"
require "intcode.cr"

def part1(prog : Array(Int64))
  ic = IntCode.new(prog)
  bad = Set(String).new
  ["giant electromagnet", "infinite loop",
   "photons", "escape pod", "molten lava"].each do |x|
    bad.add(x)
  end
  inv = Set(String).new
  s = ""
  lastDir = ""
  lastIndex = 0
  while true
    rc = ic.run()
    if rc == 2 || rc == 1
      if ic.outp.size() > 0
        while ic.outp.size() > 0
          s += ic.outp.shift.chr
        end
        #print s
        ans = s.rindex(" on the keypad")
        if ans
          return s[ans-9...ans]
        end
        if s.index("eject", lastIndex)
          if inv.size == 8
            if debug()
              print "Found exit and we have all items\n"
            end
            [1, 2, 3, 4, 5, 6, 7, 8].each do |n|
              inv.to_a.each_combination(n) do |combo|
                if debug()
                  print "Trying combination", combo, "\n"
                end
                inv.each do |item|
                  ic.addInput("drop " + item + "\n")
                end
                combo.each do |item|
                  ic.addInput("take " + item + "\n")
                end
                ic.addInput(lastDir + "\n")
              end
            end
            if debug()
              print "Sent combinations\n"
            end
            next
          else
            if debug()
              print "Found exit but we still need more items\n"
            end
          end
        end
        ii = s.index("Items here:", lastIndex)
        if ii
          ii += 12
          items = Set(String).new
          while s[ii] == '-'
            ei = s.index('\n', ii)
            if ei
              item = s[ii+2...ei]
              ii = ei+1
              if bad.includes?(item)
                if debug()
                  print "Ignoring bad item ", item, "\n"
                end
              else
                items << item
              end
            else
              break
            end
          end
          if items.size > 0
            items.each do |item|
              if debug()
                print "Attempting to pick up ", item, "\n"
              end
              ic.addInput("take " + item + "\n")
              inv << item
            end
            lastIndex = s.size
            next
          end
        end
        doors = s[s.rindex("Doors here lead")..-1]
        dirs = Set(String).new
        ["north", "south", "east", "west"].each do |d|
          if doors.includes?(d)
            dirs.add(d)
          end
        end
        dir = dirs.to_a.sample(1)[0]
        #print "Sending ", dir, "\n"
        ic.addInput(dir + "\n")
        lastDir = dir
        lastIndex = s.size
      end
    end
  end
end

inp = readinputints()

print "Part 1: ", part1(inp), "\n"
