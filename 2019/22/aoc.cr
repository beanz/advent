require "aoc-lib.cr"
require "big.cr"

# From https://stackoverflow.com/questions/59454729/how-to-compute-a-modular-exponentiation-in-crystal
@[Link("gmp")]
lib LibGMP
  fun mpz_powm_sec = __gmpz_powm_sec(rop : MPZ*, base : MPZ*, exp : MPZ*, mod : MPZ*)
end

inp = readinputlines()

# https://rosettacode.org/wiki/Modular_inverse#Crystal
def modinv(a0, m0)
  return 1 if m0 == 1
  a, m = a0, m0
  x0, inv = 0, 1
  while a > 1
    inv -= (a // m) * x0
    a, m = m, a % m
    x0, inv = inv, x0
  end
  inv += m0 if inv < 0
  inv
end

enum ShuffleKind
  Deal
  Cut
  DealInc
end


class Shuffle
  property kind : ShuffleKind
  property num : BigInt
  def initialize(s : String)
    if s.starts_with?("deal into")
      @kind = ShuffleKind::Deal
      @num = BigInt.new
      return
    end
    @num = BigInt.new(s.split(' ').last.to_i64)
    if s.starts_with?("cut")
      @kind = ShuffleKind::Cut
    else
      @kind = ShuffleKind::DealInc
    end
  end
  def params(a : BigInt, b : BigInt, num_cards : BigInt)
    na : BigInt
    nb : BigInt
    case @kind
    when ShuffleKind::Deal
      na = BigInt.new(-a)
      nb = BigInt.new(-b)-BigInt.new(1)
    when ShuffleKind::Cut
      na = a
      nb = b - @num
    else
      na = a * @num
      nb = b * @num
    end
    return [na % num_cards, nb % num_cards]
  end
  def reverse_params(a : BigInt, b : BigInt, num_cards : BigInt)
    na : BigInt
    nb : BigInt
    case @kind
    when ShuffleKind::Deal
      na = BigInt.new(-a)
      nb = BigInt.new(-b)-BigInt.new(1)
    when ShuffleKind::Cut
      na = a
      nb = b + @num
    else
      m = modinv(@num, num_cards)
      na = a * m
      nb = b * m
    end
    return [na % num_cards, nb % num_cards]
  end
end

class Game
  property shuffles : Array(Shuffle)
  property cards : BigInt
  def initialize(inp, cards)
    @shuffles = Array(Shuffle).new
    inp.each do |l|
      @shuffles << Shuffle.new(l)
    end
    @cards = BigInt.new(cards)
  end
  def params()
    a = BigInt.new(1)
    b = BigInt.new(0)
    (0..@shuffles.size-1).each do |i|
      a, b = @shuffles[i].params(a, b, @cards)
    end
    return a, b
  end
  def forward(card : Int64)
    a, b = params()
    c = BigInt.new(card)
    return (((a * c) + b) % @cards).to_i64
  end
  def reverse_params()
    a = BigInt.new(1)
    b = BigInt.new(0)
    (0..@shuffles.size-1).reverse_each do |i|
      a, b = @shuffles[i].reverse_params(a, b, @cards)
    end
    return a, b
  end
  def backward(card : Int64, rounds : Int64)
    a, b = reverse_params()
    exp = BigInt.new
    LibGMP.mpz_powm_sec(exp, a, BigInt.new(rounds), cards)
    invmod = modinv(a-1, @cards)
    return ((((exp-1) * invmod) * b) + (exp * card)) % @cards
  end
end

g = Game.new(inp, 10007)
print "Part 1: ", g.forward(2019), "\n"

g = Game.new(inp, 119315717514047)
print "Part 2: ", g.backward(2020, 101741582076661), "\n"
