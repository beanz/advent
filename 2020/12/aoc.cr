require "aoc-lib.cr"

class Nav
  property inst

  def initialize(inp : Array(String))
    @inst = Array(Tuple(Char,Int32)).new
    inp.each do |l|
      @inst << {l[0], l[1..].to_i32}
    end
  end
  def part1()
    dir = [1,0]
    pos = [0,0]
    @inst.each do |m|
      case m[0]
      when 'F'
        pos[0] += dir[0] * m[1]
        pos[1] += dir[1] * m[1]
      when 'N'
        pos[1] -= m[1]
      when 'S'
        pos[1] += m[1]
      when 'E'
        pos[0] += m[1]
      when 'W'
        pos[0] -= m[1]
      when 'L'
        (1..m[1]//90).each do |_|
          dir[0], dir[1] = dir[1], -1*dir[0]
        end
      when 'R'
        (1..m[1]//90).each do |_|
          dir[0], dir[1] = -1 * dir[1], dir[0]
        end
      end
    end
    return pos[0].abs+pos[1].abs
  end
  def part2()
    dir = [1,0]
    pos = [0,0]
    wp = [10,-1]
    @inst.each do |m|
      case m[0]
      when 'F'
        pos[0] += wp[0] * m[1]
        pos[1] += wp[1] * m[1]
      when 'N'
        wp[1] -= m[1]
      when 'S'
        wp[1] += m[1]
      when 'E'
        wp[0] += m[1]
      when 'W'
        wp[0] -= m[1]
      when 'L'
        (1..m[1]//90).each do |_|
          wp[0], wp[1] = wp[1], -1*wp[0]
        end
      when 'R'
        (1..m[1]//90).each do |_|
          wp[0], wp[1] = -1 * wp[1], wp[0]
        end
      end
    end
    return pos[0].abs+pos[1].abs
  end
end

inp = readinputlines()

nav = Nav.new(inp)

print "Part 1: ", nav.part1(), "\n"
print "Part 2: ", nav.part2(), "\n"
