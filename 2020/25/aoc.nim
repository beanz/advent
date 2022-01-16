import aoclib

let MODULUS = 20201227'u

proc loopSize(t : uint) : uint =
  let s = 7'u
  var p = 1'u
  var l = 0'u
  while p != t:
    p *= s
    p = p mod MODULUS
    l += 1
  return l

proc expMod(a : var uint, b : var uint, m : uint) : uint =
  var c = 1'u
  while b > 0:
    if (b mod 2) == 1:
      c *= a
      c = c mod m
    a *= a
    a = a mod m
    b = b div 2
  return c

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var ints = Uints(inp)
  let cardPub = ints[0]
  var doorPub = ints[1]
  var ls = loopSize(cardPub)
  if debug():
    echo cardPub
    echo doorPub
    echo ls
  let p1 = expMod(doorPub, ls, MODULUS)
  if not bench:
    echo "Part 1: ", p1
)
