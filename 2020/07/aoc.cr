require "aoc-lib.cr"

def parts(inp) : {Int32, Int32}
  bags = Hash(String, Array(Tuple(Int64, String))).new
  rbags = Hash(String, Array(String)).new
  inputlines(inp).each do |l|
    ls = l.split(" bags contain ")
    next if ls[1].starts_with?("no other")
    bags[ls[0]] = Array(Tuple(Int64, String)).new
    ls[1].split(", ").each do |spec|
      ss = spec.split(" ")
      bag = ss[1] + " " + ss[2]
      bags[ls[0]] << {ss[0].to_i64, bag}
      if !rbags.has_key?(bag)
        rbags[bag] = Array(String).new
      end
      rbags[bag] << ls[0]
    end
  end

  s = Set(String).new
  part1(rbags, "shiny gold", s)
  return s.size, part2(bags, "shiny gold")-1
end

def part1(g, bag, set)
  return set unless g.has_key?(bag)
  g[bag].each do |outer|
    set.add(outer)
    part1(g, outer, set)
  end
  return set
end

def part2(g, bag)
  return 1 unless g.has_key?(bag)
  c = 1
  g[bag].each do |inner|
    c += inner[0] * part2(g, inner[1])
  end
  return c
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  p1, p2 = parts(inp)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
