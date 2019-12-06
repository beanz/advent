inp = File.read_lines("input.txt")

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

class Game
  def initialize(inp)
    @orbits = Hash(String, String).new
    @cache = Hash(String, Hash(String, Int64)).new
    inp.each do |l|
      s = l.split(")")
      @orbits[s[1]] = s[0]
    end
  end
  def parents(obj : String)
    if @cache.has_key?(obj)
      return @cache[obj]
    end
    p = Hash(String, Int64).new
    if ! @orbits.has_key?(obj)
      @cache[obj] = p
      return p
    end
    parent = @orbits[obj]
    p[parent] = 0
    parents(parent).each do |grand, dist|
      p[grand] = dist + 1
    end
    @cache[obj] = p
    return p
  end
  def part1()
    s = 0
    @orbits.each_key do |obj|
      s += parents(obj).size
    end
    return s
  end
  def part2()
    p1 = parents("YOU")
    p2 = parents("SAN")
    dist = 9223372036854775807_i64
    p1.each do |p, d1|
      if p2.has_key?(p)
        d = d1 + p2[p]
        if dist > d
          dist = d
        end
      end
    end
    return dist
  end
end

def part2(inp)
  return 2
end

g = Game.new(inp)

aeq(Game.new(["COM)B","B)C","C)D","D)E","E)F","B)G",
              "G)H","D)I","E)J","J)K","K)L"]).part1(), 42)
aeq(Game.new(["COM)B","B)C","C)D","D)E","E)F","B)G","G)H",
              "D)I","E)J","J)K","K)L","K)YOU","I)SAN"]).part2(), 4)


print "Part1: ", g.part1(), "\n"

print "Part2: ", g.part2(), "\n"
