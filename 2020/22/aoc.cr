require "aoc-lib.cr"

class Game
  property decks : Tuple(Array(Int32), Array(Int32))
  def initialize(inp)
    d0 = inp[0].split("\n").skip(1).map &.to_i32
    d1 = inp[1].split("\n").skip(1).map &.to_i32
    @decks = {d0, d1}
  end
  def score(d)
    return d.map_with_index { |c, i| (d.size - i) * d[i] }.sum
  end
  def combat(decks, part2 : Bool)
    round = 1
    seen = Set(Int32).new
    while decks[0].size > 0 && decks[1].size > 0
      print round, ": d1=", decks[0], " d2=", decks[1], "\n" if debug()
      k = score(decks[0]) * score(decks[1])
      if seen.includes?(k)
        return { 0, decks[0] }
      end
      seen << k
      c = { decks[0].shift, decks[1].shift }
      if part2 && decks[0].size >= c[0] && decks[1].size >= c[1]
        print "Starting subgame\n" if debug()
        winner, _ = combat({ decks[0].first(c[0]), decks[1].first(c[1]) }, true)
      else
        winner = c[0] > c[1] ? 0 : 1
      end
      print round, ": player ", winner+1, "\n" if debug()
      decks[winner] << c[winner]
      decks[winner] << c[1-winner]
      round += 1
    end
    return decks[0].size > 0 ? { 0, decks[0] } : { 1, decks[1] }
  end
  def play(part2 : Bool)
    _, d = combat(decks.clone, part2)
    return score(d)
  end
  def part1()
    return play(false)
  end
  def part2()
    return play(true)
  end
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  g = Game.new(inputchunks(inp))
  p1 = g.part1()
  p2 = g.part2()
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
