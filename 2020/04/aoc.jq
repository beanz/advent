#!/bin/sh
exec jq -r --slurp --raw-input '
def vyr(v;min;max): (v | tonumber) as $n | ($n >= min and $n <= max);
def vhgt(v): v[-2:] as $u | (v[:-2]|tonumber) as $n |
             (($u == "cm" and $n >= 150 and $n <= 193) or
              ($u == "in" and $n >= 59 and $n <= 76));
def vhcl(v): v | match("^#[0-9a-f]{6}$");
def vecl(v): v | match("^(?:amb|blu|brn|gry|grn|hzl|oth)$");
def vpid(v): v | match("^\\d{9}$");
. | split("\n\n")
  | [.[] | split("\n") | [.[] | split(" ") ] ]
  | map(flatten)
  | map(reduce (.[] | split(":")) as [$k, $v] ({}; .[$k] = $v))
  | [(.[] | select(has("byr") and has("iyr") and has("eyr") and has("iyr") and
                   has("hgt") and has("hcl") and has("ecl") and has("pid")))]
  | [
     (. | length),
     ([.[] | select(vyr(.byr;1920;2002) and
                    vyr(.iyr;2010;2020) and
                    vyr(.eyr;2020;2030) and
                    vhgt(.hgt) and
                    vhcl(.hcl) and
                    vecl(.ecl) and
                    vpid(.pid))]| length)
    ] | "Part 1: \(.[0])\nPart 2: \(.[1])"'
