require "aoc-lib.cr"
require "point.cr"

class Nav
  property inst

  def initialize(inp : Array(String))
    @inst = Array(Tuple(Char,Int32)).new
    inp.each do |l|
      @inst << {l[0], l[1..].to_i32}
    end
  end
  def part1()
    dir = Point.new('E')
    pos = Point.new(0,0)
    @inst.each do |m|
      case m[0]
      when 'F'
        pos.move(dir, m[1])
      when 'N'
        pos.move_y(-1 * m[1])
      when 'S'
        pos.move_y(m[1])
      when 'E'
        pos.move_x(m[1])
      when 'W'
        pos.move_x(-1 * m[1])
      when 'L'
        (1..m[1]//90).each do |_|
          dir.ccw()
        end
      when 'R'
        (1..m[1]//90).each do |_|
          dir.cw()
        end
      end
    end
    return pos.manhattan()
  end
  def part2()
    pos = Point.new(0,0)
    wp = Point.new(10,-1)
    @inst.each do |m|
      case m[0]
      when 'F'
        pos.move(wp, m[1])
      when 'N'
        wp.move_y(-1 * m[1])
      when 'S'
        wp.move_y(m[1])
      when 'E'
        wp.move_x(m[1])
      when 'W'
        wp.move_x(-1 * m[1])
      when 'L'
        (1..m[1]//90).each do |_|
          wp.ccw()
        end
      when 'R'
        (1..m[1]//90).each do |_|
          wp.cw()
        end
      end
    end
    return pos.manhattan()
  end
end

input = {{ read_file("input.txt") }}

benchme(input) do |inp, bench|
  nav = Nav.new(inputlines(inp))
  p1 = nav.part1()
  p2 = nav.part2()
  if !bench
    print "Part 1: ", p1, "\n"
    print "Part 2: ", p2, "\n"
  end
end
