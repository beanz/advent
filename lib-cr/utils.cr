def rotate_strings(lines : Array(String))
  w = lines[0].size
  h = lines.size
  n = Array(String).new(w, "")
  (0...w).each do |i|
    (0...h).each do |j|
      n[i] += lines[w-1-j][i]
    end
  end
  return n
end

def isqrt(n) # https://github.com/crystal-lang/crystal/issues/8920
  raise "ivalid negative integer" if n < 0
  return n if n < 2
  b = n.to_s(2).size
  one = typeof(n).new(1)  # value 1 of type self
  x = one << ((b-1) >> 1) | n >> ((b >> 1) + 1)
  while (t = n // x) < x; x = (x + t) >> 1 end
  x
end
