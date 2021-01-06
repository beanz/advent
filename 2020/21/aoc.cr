require "aoc-lib.cr"

class Game
  property allergens
  property ingredients
  property possible

  def initialize(inp)
    @allergens = Hash(String, Set(Int32)).new
    @ingredients = Hash(String, Set(Int32)).new
    @possible = Hash(String, Set(String)).new
    inp.each_with_index do |l, i|
      ls = l.split(" (contains ")
      ings = ls[0].split(" ")
      alls = ls[1][..ls[1].size-2].split(", ")
      alls.each do |a|
        @allergens[a] = Set(Int32).new unless @allergens.has_key?(a)
        @allergens[a] << i
      end
      ings.each do |ing|
        @ingredients[ing] = Set(Int32).new unless @ingredients.has_key?(ing)
        @ingredients[ing] << i
      end
    end
    @ingredients.each_key do |ing|
      @allergens.each do |all, line_nums|
        maybe_this_allergen = true
        line_nums.each do |n|
          if !@ingredients[ing].includes?(n)
            maybe_this_allergen = false
          end
        end
        if maybe_this_allergen
          print ing, " could be ", all, "\n" if debug()
          @possible[ing] = Set(String).new unless @possible.has_key?(ing)
          @possible[ing] << all
        end
      end
    end
  end
  def part1()
    c = 0
    @ingredients.each do |ing, lines|
      if !@possible.has_key?(ing)
        c += lines.size
      end
    end
    return c
  end
  def part2()
    res = Array(Tuple(String,String)).new
    while @possible.size > 0
      @possible.select { |k, v| v.size == 1 }.each do |ing, alls|
        all = alls.first
        print ing, " is ", all, "\n" if debug()
        res << {all, ing}
        @possible.delete(ing)
        @possible.each_value { |x| x.delete(all) }
      end
    end
    return res.sort_by { |x| x[0] }.map { |x| x[1] }.join(",")
  end
end

inp = readinputlines()
g = Game.new(inp)

print "Part 1: ", g.part1(), "\n"
print "Part 2: ", g.part2(), "\n"
