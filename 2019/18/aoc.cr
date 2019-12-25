require "../lib/input.cr"
require "../lib/point.cr"
require "priority-queue"

struct SearchRecord
  property pos
  property steps
  property remaining
  property keys
  property path
  property sortedPath
  def initialize(@pos : Point, @steps : Int32, @remaining : Int32,
                 @keys : Set(Char), @path : String, @sortedPath : String)
  end
end

struct QuadRecord
  property p
  property name
  def initialize(@p : Point, @name : Char)
  end
end

class Rogue
  property m
  property bb
  property pos
  property keys
  property quadkeys
  def initialize(lines : Array(String))
    @m = Hash(Point, Char).new
    @bb = BoundingBox.new
    @bb.add(Point.new(0,0))
    @bb.add(Point.new(lines[0].size()-1, lines.size()-1))
    @pos = Point.new(-1,-1)
    @keys = 0
    @quadkeys = Hash(Char, Set(Char)).new
    lines.each_with_index do |line, y|
      line.each_char_with_index do |ch, x|
        p = Point.new(x,y)
        if ch == '@'
          @pos = p
          ch = '.'
        elsif 'a' <= ch && ch <= 'z'
          @keys += 1
        end
        @m[p] = ch
      end
    end
  end
  def string()
    s = ""
    (@bb.min.y .. @bb.max.y).each do |y|
      (@bb.min.x .. @bb.max.x).each do |x|
        p = Point.new(x,y)
        if x == @pos.x && y == @pos.y
          s += "@"
        else
          s += @m[p]
        end
      end
      s += "\n"
    end
    return s
  end
  def optimaze()
    changes = 1
    while changes > 0
      changes = 0
      (@bb.min.y .. @bb.max.y).each do |y|
        (@bb.min.x .. @bb.max.x).each do |x|
          p = Point.new(x,y)
          if @m[p] != '.'
            next
          end
          if @pos.x == x && @pos.y == y
            next
          end
          nw = 0
          p.neighbours().each do |np|
            if @m[np] == '#'
              nw += 1
            end
          end
          if nw > 2
            @m[p] = '#'
            changes += 1
          end
        end
      end
    end
  end
  def isKeyInQuad(key, quad)
    if quad == '*'
      return true
    end
    if ! @quadkeys.has_key?(quad)
      raise Exception.new("Unexpected quad: #{quad}")
    end
    return @quadkeys[quad].includes?(key)
  end
  def findKeys(pos, quad)
    @quadkeys[quad] = Set(Char).new(50)
    visited = Set(Point).new(100)
    search = Deque(Point).new
    search << pos
    while search.size() > 0
      cur = search.shift
      ch = @m[cur]
      if ch == '#'
        next
      end
      if ! visited.add?(cur)
        next
      end
      if 'a' <= ch && ch <= 'z'
        @quadkeys[quad].add(ch)
      end
      cur.neighbours().each do |np|
        search << np
      end
    end
  end
  def find(pos : Point, quad : Char)
    expectedKeys = if quad == '*'
                     @keys
                   else
                     @quadkeys[quad].size()
                   end
    #print "Searching for ", expectedKeys, " keys in quad ", quad, "\n"
    visited = Hash(String,Int32).new
    q = Priority::Queue(SearchRecord).new
    sr = SearchRecord.new(pos, 0, expectedKeys, Set(Char).new(expectedKeys),
                          "", "")
    q.push expectedKeys, sr
    min = Int32::MAX
    while q.size > 0
      cur = q.pop.value
      ch = @m[cur.pos]
      #print "checking ", cur.pos, " ", cur.remaining,
      #      " \"", cur.path, "\" '",  ch, "'\n"
      if ch == '#'
        next
      end
      if cur.steps > min
        #print "  too many steps: ", cur.steps, " > ", min, "\n"
        next
      end
      if 'A' <= ch && ch <= 'Z'
        lch = ch.downcase
        if ! cur.keys.includes?(lch) && isKeyInQuad(lch, quad)
          #print "  blocked by door ", ch, "\n";
          next
        end
      elsif 'a' <= ch && ch <= 'z'
        if cur.keys.add?(ch)
          #print "  found key ", ch, " (", cur.steps, ")\n"
          cur.remaining -= 1
          cur.path += ch
          cur.sortedPath = cur.path.chars.sort.join("")
          if cur.remaining == 0
            #print "Found all keys via ", cur.path, " in ",cur.steps," steps\n"
            if min > cur.steps
              min = cur.steps
            end
            next
          end
        end
      end
      vkey = cur.pos.x.to_s + "!" + cur.pos.y.to_s + "!" + cur.sortedPath
      if visited.has_key?(vkey) && visited[vkey] <= cur.steps
        #print "  de ja vu (", vkey, ")\n"
        next
      end
      visited[vkey] = cur.steps
      cur.pos.neighbours().each do |np|
        if @m[np] == '#'
          next
        end
        #print "  adding ", np, "\n"
        sr = SearchRecord.new(np, cur.steps+1, cur.remaining, cur.keys.clone,
                              cur.path.clone, cur.sortedPath.clone)
        q.push cur.remaining, sr
      end
    end
    return min
  end
  def part1()
    return find(@pos, '*')
  end
  def part2()
    @pos.neighbours().each do |np|
      @m[np] = '#'
    end
    sum = 0
    [QuadRecord.new(Point.new(-1,-1), 'A'),
     QuadRecord.new(Point.new(1,-1), 'B'),
     QuadRecord.new(Point.new(-1,1), 'C'),
     QuadRecord.new(Point.new(1,1), 'D')].each do |qr|
      start = Point.new(@pos.x + qr.p.x, @pos.y + qr.p.y)
      quad = qr.name
      findKeys(start, quad)
      #print "Quad ", quad, " / ", start,
      #      " has ", @quadkeys[quad].size(), " keys\n"
      sum += find(start, quad)
    end
    return sum
  end
end

file = "input.txt"
if ARGV.size > 0
  file = ARGV[0]
end
lines = readlines(file)

rogue = Rogue.new(lines)
rogue.optimaze()
print "Part1: ", rogue.part1(), "\n"
print "Part2: ", rogue.part2(), "\n"
