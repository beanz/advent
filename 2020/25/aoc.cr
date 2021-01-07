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

inp = readinputints()
card_pub = inp[0].to_u64
door_pub = inp[1].to_u64
ls = loop_size(card_pub)
print ls, "\n" if debug()
p1 = exp_mod(door_pub, ls, Modulus)

print "Part 1: ", p1, "\n"
