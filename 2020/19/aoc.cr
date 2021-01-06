require "aoc-lib.cr"

struct Rule
  property ch : String
  property options : Array(Array(Int32))
  def initialize(@ch, @options = [] of Array(Int32))
  end
end

class Game
  property rules : Hash(Int32, Rule)
  property values : Array(String)
  def initialize(inp)
    @rules = Hash(Int32, Rule).new
    @values = inp[1].split("\n")
    inp[0].split("\n").each do |rl|
      ss = rl.split(": ")
      n = ss[0].to_i32
      if ss[1][0] == '"'
        @rules[n] = Rule.new(ss[1][1].to_s)
      else
        options = ss[1].split(" | ").map { |o| o.split(" ").map &.to_i32 }
        @rules[n] = Rule.new("", options)
      end
    end
  end

  def regexp(i : Int32)
    r = @rules[i]
    if r.ch != ""
      return r.ch
    end
    res = r.options.map { |o| o.map {|rn| regexp(rn) }.join }.join("|")
    if debug()
      print "re[i] = ", res, "\n"
    end
    return "(?:" + res + ")"
  end
  def part1()
    re = Regex.new("^" + regexp(0) + "$")
    if debug()
      print re, "\n"
    end
    c = 0
    @values.each do |v|
      if re.match(v)
        c += 1
      end
    end
    return c
  end
  def part2()
    re31 = regexp(31)
    re42 = regexp(42)
    rules[8] = Rule.new(re42 + "+")
    repeats = 5
    ns = Array(String).new(repeats)
    (1..repeats).each do |n|
      ns << re42 + "{"+n.to_s+"}" + re31 + "{"+n.to_s+"}"
    end
    rules[11] = Rule.new("(?:" + ns.join("|") +")")
    return part1()
  end
end

inp = readinputchunks()
g = Game.new(inp)

print "Part 1: ", g.part1(), "\n"
print "Part 2: ", g.part2(), "\n"
