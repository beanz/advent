X = 0
Y = 1
Z = 2
VX = 3
VY = 4
VZ = 5

class Moon
  property data
  def initialize(x : Int64, y : Int64, z : Int64,
                 vx : Int64, vy : Int64, vz : Int64)
    @data = Array(Int64){x, y, z, vx, vy, vz}
  end
  def [](i)
    return data[i]
  end
  def []=(i, v)
    data[i] = v
  end
end

def pp_moon(m)
  str = String.build do |ss|
    ss << "pos=<x=" << m[X] << ", y=" << m[Y] << ", z=" << m[Z] <<
          ">, vel=<x=" << m[VX] << ", y=" << m[VY] << ", z=" << m[VZ] << ">";
  end
  return str
end

def abs(x)
  if x < 0
    return -x
  end
  return x
end

def energy(m)
  return (abs(m[X]) + abs(m[Y]) + abs(m[Z])) *
         (abs(m[VX]) + abs(m[VY]) + abs(m[VZ]))
end

def pp_moons(moons)
  str = String.build do |ss|
    moons.each do |m|
      ss << pp_moon(m) << "\n"
    end
  end
  return str
end

def axis_state(moons, axis)
  str = String.build do |ss|
    moons.each do |m|
      ss << m[axis] << ":" << m[VX+axis] << "\n"
    end
  end
  return str
end

def run_step(moons)
  (0..moons.size()-1).each do |i|
    (i..moons.size()-1).each do |j|
      {X, Y, Z}.each do |axis|
        if moons[i][axis] > moons[j][axis]
          moons[i][VX+axis] -= 1
          moons[j][VX+axis] += 1
        elsif moons[i][axis] < moons[j][axis]
          moons[i][VX+axis] += 1
          moons[j][VX+axis] -= 1
        end
      end
    end
  end

  moons.each do |m|
    {X, Y, Z}.each do |axis|
      m[axis] += m[VX+axis]
    end
  end
end

def part1(moons, steps)
  (1..steps).each do |step|
    run_step(moons)
    #print "After ", step, " steps\n", pp_moons(moons), "\n"
  end
  s = 0
  moons.each do |m|
    s += energy(m)
  end
  return s
end

def part2(moons)
  #print "After 0 steps:\n", pp_moons(moons), "\n";
  cycle = [-1_i64,-1_i64,-1_i64]
  initialState = Array(String).new
  {X, Y, Z}.each do |axis|
    initialState << axis_state(moons, axis)
  end
  steps = 0_i64
  while cycle[X] == -1 || cycle[Y] == -1 || cycle[Z] == -1
    steps += 1
    run_step(moons)
    #print "After ", steps, " steps:\n", pp_moons(moons), "\n"
    {X, Y, Z}.each do |axis|
      if cycle[axis] == -1 && initialState[axis] == axis_state(moons, axis)
        #print "Found ", axis, " cycle at ", steps, "\n"
        cycle[axis] = steps
      end
    end
  end
  return cycle[X].lcm(cycle[Y]).lcm(cycle[Z])
end

def readfile(file)
  File.read(file).rstrip("\n").split("\n").map do |l|
    v = l.delete("<>=,xyz").split(" ").map &.to_i64
    Moon.new(v[0], v[1], v[2], 0, 0, 0)
  end
end

def aeq(act, exp)
  if act != exp
    raise Exception.new("assert failed: #{act} != #{exp}")
  end
end

aeq(part1(readfile("test1a.txt"),10), 179)
aeq(part1(readfile("test1b.txt"),100), 1940)

print "Part1: ", part1(readfile("input.txt"), 1000), "\n"

aeq(part2(readfile("test1a.txt")), 2772)
aeq(part2(readfile("test2.txt")), 4686774924)

print "Part2: ", part2(readfile("input.txt")), "\n"
