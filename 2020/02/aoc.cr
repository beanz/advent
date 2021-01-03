require "aoc-lib.cr"

db = readinputlists()

c = 0
db.each do |e|
  cc = e[3].count(e[2])
  if e[0].to_i64() <= cc <= e[1].to_i64()
    c += 1
  end
end
print "Part 1: ", c, "\n"

c = 0
db.each do |e|
  c1 = e[3][e[0].to_i64()-1]
  c2 = e[3][e[1].to_i64()-1]
  if c1 != c2 && (c1 == e[2][0] || c2 == e[2][0])
    c += 1
  end
end
print "Part 2: ", c, "\n"
