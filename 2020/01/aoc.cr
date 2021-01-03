require "aoc-lib.cr"

expenses = readinputints()

seen = Set(Int64).new(expenses.size)
expenses.each do |i|
  if seen.includes?(2020-i)
    print "Part 1: ", i*(2020-i), "\n"
  end
  seen.add(i)
end

expenses.combinations(3).each do |i|
  if i.sum == 2020
    print "Part 2: ", i.product, "\n"
    break
  end
end
