require "aoc-lib.cr"

fields = {
  "byr" => ->(x : String) { /^\d{4}$/.match(x) && 1920 <= x.to_i32 <= 2002 },
  "iyr" => ->(x : String) { /^\d{4}$/.match(x) && 2010 <= x.to_i32 <= 2020 },
  "eyr" => ->(x : String) { /^\d{4}$/.match(x) && 2020 <= x.to_i32 <= 2030 },
  "hgt" => ->(x : String) {
    (x.ends_with?("cm") && 150 <= x[0...-2].to_i32 <= 193 ) ||
      (x.ends_with?("in") && 59 <= x[0...-2].to_i32 <= 76 )
  },
  "hcl" => ->(x : String) { /^\#[0-9a-f]{6}$/.match(x) },
  "ecl" => ->(x : String) { /^(?:amb|blu|brn|gry|grn|hzl|oth)$/.match(x) },
  "pid" => ->(x : String) { /^\d{9}$/.match(x) },
}

records = readinputchunkyrecords()

c = 0
records.each do |r|
  valid = true
  fields.each_key do |k|
    valid = false if !r.has_key?(k)
  end
  c+=1 if valid
end
print "Part 1: ", c, "\n"
c = 0
records.each do |r|
  valid = true
  fields.each_key do |k|
    valid = false if !(r.has_key?(k) && fields[k].call(r[k]))
  end
  c+=1 if valid
end
print "Part 2: ", c, "\n"
