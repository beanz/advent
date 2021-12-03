require "aoc-lib.cr"

x = 0
y = 0
a = 0
y2 = 0
readinputlines().each do |l|
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

print "Part 1: ", x*y, "\n"
print "Part 2: ", x*y2, "\n"
