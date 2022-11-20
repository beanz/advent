require "aoc-lib.cr"


def parts(inp) : {Int32, Int32}
  x = 0
  y = 0
  a = 0
  y2 = 0
  inp.each do |l|
    n = l[-1].to_i
    case l[0]
    when 'f'
      x += n
      y2 += n * a
    when 'd'
      y += n
      a += n
    when 'u'
      y -= n
      a -= n
    end
  end
  return x*y, x*y2
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  p1, p2 = parts(inputlines(inp))
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
