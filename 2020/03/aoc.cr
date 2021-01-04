require "aoc-lib.cr"

class Trees
  property map
  property w : Int32
  property h : Int32

  def initialize(inp : Array(String))
    @h = inp.size
    @w = inp[0].size
    @map = Set(Int64).new
    inp.each_index do |y|
      inp[y].split("").each_index do |x|
        @map.add((y*@w+x).to_i64) if inp[y][x] == '#'
      end
    end
  end

  def tree?(x, y)
    return @map.includes?(y*@w+(x%@w))
  end

  def calc(sx : Int32, sy : Int32)
    c = 0
    x = sx
    y = sy
    while y < @h
      c += 1 if self.tree?(x, y)
      x += sx
      y += sy
    end
    return c
  end
end

trees = Trees.new(readinputlines())
print "Part 1: ", trees.calc(3, 1), "\n"
slopes = [[1,1],[3,1],[5,1],[7,1],[1,2]]
print "Part 2: ", slopes.map { |s| trees.calc(s[0],s[1]).to_i64 }.product, "\n"
