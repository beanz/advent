require "aoc-lib.cr"

def path(w)
  points = Hash(Tuple(Int64, Int64), Int64).new
  x = 0_i64
  y = 0_i64
  steps = 0_i64
  w.split(",").each do |m|
    d = m[0].to_s
    c = m.chars.skip(1).join.to_i64
    (1..c).each do
      case d
      when "U"
        y -= 1
      when "D"
        y += 1
      when "L"
        x -= 1
      when "R"
        x += 1
      end
      steps += 1
      points[{x,y}] = steps
    end
  end
  return points
end

def calc(inp)
  p1 = path(inp[0])
  p2 = path(inp[1])
  dist = 9223372036854775807_i64
  steps = 9223372036854775807_i64
  p1.each_key do |p|
    if p2.has_key?(p)
      s = p1[p] + p2[p]
      if s < steps
        steps = s
      end
      d = p[0].abs + p[1].abs
      if d < dist
        dist = d
      end
    end
  end
  return {dist,steps}
end

aeq(calc(["R8,U5,L5,D3", "U7,R6,D4,L4"]), {6, 30})
aeq(calc(["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
          "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]), {135, 410})
aeq(calc(["R75,D30,R83,U83,L12,D49,R71,U7,L72",
          "U62,R66,U55,R34,D71,R55,D58,R83"]), {159, 610})

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  res = calc(inputlines(inp))
  if !bench
    print "Part 1: ", res[0], "\n"
    print "Part 2: ", res[1], "\n"
  end
end
