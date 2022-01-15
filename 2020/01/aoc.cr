require "aoc-lib.cr"

def parts(inp) : {Int64, Int64}
  expenses = inputlines(inp).map &.to_i64
  p1 = 0
  seen = Set(Int64).new(expenses.size)
  products = Hash(Int64, Int64).new
  expenses.each do |i|
    if seen.includes?(2020-i)
      p1 = i*(2020-i)
    end
    seen.each do |j|
      products[i+j] = i*j
    end
    seen.add(i)
  end
  p2 = 0
  expenses.each do |i|
    if products.has_key?(2020-i)
      p2 = i*products[2020-i]
      break
    end
  end
  return p1.to_i64, p2.to_i64
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  p1, p2 = parts(inp)
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
