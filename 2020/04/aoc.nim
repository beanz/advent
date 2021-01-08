import aoclib, re

var records = readInputChunkyRecords()

proc inRange(x, mn:int, mx:int): bool =
  return mn <= x and x <= mx

var fields = {
  "byr": proc (x:string): bool = match(x, re"^\d{4}$") and inRange(parseInt(x), 1920, 2002),
  "iyr": proc (x:string): bool = match(x, re"^\d{4}$") and inRange(parseInt(x), 2010, 2020),
  "eyr": proc (x:string): bool = match(x, re"^\d{4}$") and inRange(parseInt(x), 2020, 2030),
  "hgt": proc (x:string): bool =
             (x[^2..^1] == "cm" and inRange(parseInt(x[0..^3]),150,193)) or
             (x[^2..^1] == "in" and inRange(parseInt(x[0..^3]),59,76))
  ,
  "hcl": proc (x:string): bool = match(x, re"^#[0-9a-f]{6}$"),
  "ecl": proc (x:string): bool =
             match(x, re"^(?:amb|blu|brn|gry|grn|hzl|oth)$"),
  "pid": proc (x:string): bool = match(x, re"^\d{9}$"),
}.toTable

var p1:int64 = 0
for r in records:
  var valid = true
  for k in fields.keys:
    if not r.contains(k):
      valid = false
  if valid:
    p1 += 1
echo "Part 1: ", p1

var p2:int64 = 0
for r in records:
  var valid = true
  for k, v in fields:
    if not (r.contains(k) and v(r[k])):
      valid = false
  if valid:
    p2 += 1

echo "Part 2: ", p2
