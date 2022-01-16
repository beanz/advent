require "aoc-lib.cr"

Modulus = 20201227

def loop_size(t : UInt64)
  p = 1_u64
  s = 7_u64
  l = 0_u64
  while (p != t)
    p *= s
    p %= Modulus
    l += 1
  end
  return l
end

def exp_mod(a, b, m)
  c = 1_u64
  while b > 0
    if b.odd?
      c *= a
      c %= m;
    end
    a *= a
    a %= m
    b //= 2
  end
  return c
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  ints = inputlines(inp).map &.to_u64
  card_pub = ints[0]
  door_pub = ints[1]
  ls = loop_size(card_pub)
  print ls, "\n" if debug()
  p1 = exp_mod(door_pub, ls, Modulus)
  if !bench
    print "Part 1: ", p1, "\n"
  end
end
