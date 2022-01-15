require "aoc-lib.cr"

def parts(inp) : {Int32, Int32}
  db = inputlists(inp)

  p1 = 0
  db.each do |e|
    cc = e[3].count(e[2])
    if e[0].to_i64() <= cc <= e[1].to_i64()
      p1 += 1
    end
  end

  p2 = 0
  db.each do |e|
    c1 = e[3][e[0].to_i64()-1]
    c2 = e[3][e[1].to_i64()-1]
    if c1 != c2 && (c1 == e[2][0] || c2 == e[2][0])
      p2 += 1
    end
  end
  return p1, p2
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  p1, p2 = parts(inp)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
