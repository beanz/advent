require "aoc-lib.cr"

def parse_buses(inp)
  departure = inp[0].to_i64
  buses = inp[1].split(",").map_with_index { |b,i| {b,i.to_i64} }.select { |bi| bi[0] != "x" }.map { |bi| {bi[0].to_i64, bi[1]} }
  if debug()
    print buses, "\n"
  end
  return {departure, buses}
end

def part1(departure, buses)
  times = buses.map { |bi| { bi[0], bi[0]-(departure%bi[0]) } }
  first = times.min_by { |bt| bt[1] }
  return first.product
end

def part2(departure, buses)
  first = buses.shift
  t = first[1]
  period = first[0]
  offset = -1
  buses.each do |b|
    bus = b[0]
    bus_num = b[1]
    offset = -1
    while true
      if debug()
        print bus, " ", bus_num, " ", t, " ", offset, "\n"
      end
      if ((t + bus_num) % bus) == 0
          if (offset == -1)
            offset = t
          else
            period = t - offset
            break
          end
      end
      t += period
    end
  end
  return offset
end

inp = readinputlines()
departure, buses = parse_buses(inp)

print "Part 1: ", part1(departure, buses), "\n"
print "Part 2: ", part2(departure, buses), "\n"
