require "aoc-lib.cr"

class Tile
  property num : Int32
  property lines : Array(String)
  property width : Int32
  property top : Int32
  property right : Int32
  property bottom : Int32
  property left : Int32

  def initialize(s : String)
    ss = s.split("\n")
    @num = ss.shift[5..8].to_i32
    @lines = ss
    @width = ss.size
    @top = @right = @bottom = @left = 0
    update_edges()
  end
  def to_s(io)
    io << "Tile " << @num << "\n" << @lines.join("\n") << "\n"
  end
  def update_edges()
    @top = @right = @bottom = @left = 0
    ei = @width - 1
    (0..ei).each do |i|
      @top <<= 1
      @right <<= 1
      @bottom <<= 1
      @left <<= 1
      if @lines[0][i] == '#'
        @top += 1
      end
      if @lines[i][ei] == '#'
        @right += 1
      end
      if @lines[ei][i] == '#'
        @bottom += 1
      end
      if @lines[i][0] == '#'
        @left += 1
      end
    end
  end
  def flip()
    @lines.reverse!
    update_edges()
  end
  def rotate()
    @lines = rotate_strings(@lines)
    update_edges()
  end
end

class Game
  property tiles
  property edges
  property starter : Int32
  property width : Int32

  def initialize(inp)
    @edges = Hash(Int32, Array(Int32)).new
    @tiles = Hash(Int32, Tile).new
    inp.each do |ts|
      tile = Tile.new(ts)
      @tiles[tile.num] = tile
      [tile.top, tile.right, tile.bottom, tile.left].each do |e|
        ce = canonical_edge(e)
        if !@edges.has_key?(ce)
          @edges[ce] = Array(Int32).new
        end
        @edges[ce] << tile.num
      end
    end
    @width = isqrt(@tiles.size)
    @starter = 0
  end

  def edge_tiles(e)
    ce = canonical_edge(e)
    return @edges[ce]
  end

  def edge_tile_count(e)
    return edge_tiles(e).size
  end

  def part1()
    p = 1_i64
    @tiles.each_value do |tile|
      c = 0
      [tile.top, tile.right, tile.bottom, tile.left].each do |e|
        if edge_tile_count(e) > 1
          c += 1
        end
      end
      if c == 2
        if debug()
          print "found corner ", tile.num, "\n";
        end
        p *= tile.num.to_i64
        @starter = tile.num # arbitrary corner tile to start with for part 2
      end
    end
    return p
  end

  def find_right_tile(n)
    t = @tiles[n]
    e = t.right
    matching = edge_tiles(e).select { |nn| nn != n }.first
    nt = @tiles[matching]
    (0..7).each do |i|
      if nt.left == e
        return nt.num
      end
      if (i == 3)
        nt.flip
      else
        nt.rotate
      end
    end
    raise "failed to rotate tile #{matching}"
  end

  def find_bottom_tile(n)
    t = @tiles[n]
    e = t.bottom
    matching = edge_tiles(e).select { |nn| nn != n }.first
    nt = @tiles[matching]
    (0..7).each do |i|
      if nt.top == e
        return nt.num
      end
      if (i == 3)
        nt.flip
      else
        nt.rotate
      end
    end
    raise "failed to rotate tile #{matching}"
  end

  def image()
    layout = Array(Int32).new
    if @starter == 0
      part1()
    end
    if debug()
      print "Starting with corner #{@starter}\n"
    end
    t = @tiles[@starter]
    while edge_tile_count(t.right) != 2 || edge_tile_count(t.bottom) != 2
      t.rotate # rotate until matching edges are right and bottom edges
    end
    layout << t.num
    (1...@width*@width).each do |i|
      tn = 0
      if (i % @width) == 0
        tn = find_bottom_tile(layout[i - @width])
      else
        tn = find_right_tile(layout[i-1])
      end
      if tn == 0
        raise "failed to find next tile"
      end
      if debug()
        print "Found #{i}: #{tn}\n"
      end
      layout << tn
    end
    res = Array(String).new
    (0...@width).each do |irow|
      (1...t.width-1).each do |trow|
        row = ""
        (0...@width).each do |icol|
          tt = @tiles[layout[irow*@width + icol]]
          row += tt.lines[trow][1..tt.width-2]
        end
        res << row
      end
    end
    return res
  end
  def part2()
    im = image()
    ih = im.size
    iw = im[0].size
    water = im.map { |l| l.count('#') }.sum
    monster = readlines("monster.txt")
    monster_size = monster.map { |l| l.count("#") }.sum
    mh = monster.size
    mw = monster[0].size
    if debug()
      print im.join("\n"), "\n"
      print monster.join("\n"), "\n"
      print "image #{iw} x #{ih} #{water}\n"
      print "monster #{mw} x #{mh} #{monster_size}\n"
    end
    mchars = 0
    (0..7).each do |i|
      (0...(ih-mh)).each do |r|
        (0...(iw-mw)).each do |c|
          match = true
          (0...mh).each do |mr|
            (0...mw).each do |mc|
              if monster[mr][mc] != '#'
                next
              end
              if im[r+mr][c+mc] != '#'
                match = false
                break
              end
            end
            if !match
              break
            end
          end
          if match
            print "found monster at #{c},#{r}\n" if debug()
            mchars += monster_size
          end
        end
      end
      if i == 3
        im.reverse!
      else
        im = rotate_strings(im)
      end
    end
    return water - mchars
  end
end

def canonical_edge(e : Int32)
  bits = e.digits(2)
  while bits.size < 10
    bits << 0
  end
  re = bits.reduce { |a, b| a <<=1; a+=b }
  return re < e ? re : e
end

#print canonical_edge(210), " == 300\n"
#print canonical_edge(791), " == 931\n"

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
