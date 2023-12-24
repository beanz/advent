import re
import sys
import z3

hail = []
for line in open(sys.argv[1]).read().strip().split('\n'):
  x, y, z, vx, vy, vz = [int(x) for x in re.findall(r'-?\d+', line)]
  hail.append(((x,y,z, vx, vy, vz)))

VAR = lambda v: z3.Real(v) # tried bitvec, int and real use fastest
x, y, z, vx, vy, vz = [VAR(v) for v in ['x','y', 'z','vx', 'vy', 'vz']]

s = z3.Solver()

for i, a in enumerate(hail[:3]):
  (ax, ay, az, vax, vay, vaz) = a
  t = VAR(f't{i}')
  s.add(t >= 0)
  s.add(x + vx * t == ax + vax * t)
  s.add(y + vy * t == ay + vay * t)
  s.add(z + vz * t == az + vaz * t)

assert s.check() == z3.sat

m = s.model()
print(m.eval(x + y + z).as_long())
