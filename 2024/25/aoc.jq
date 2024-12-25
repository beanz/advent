#!/bin/sh
exec jq -L../../lib-jq -r --slurp --raw-input '
  include "util";
  split("\n\n") | map(
    split("\n")|map(split(""))|transpose|
    [
     (if (.[0][0] == "#") then "L" else "K" end),
     (map(((map(select(. == "#"))|length)-1)))
    ]
  ) |pairs
    |map(select(.[0][0] != .[1][0]))
    |map([.[0][1], .[1][1]])|map(transpose|(map(.[0]+.[1])|max)) |
  [ (map(select(. < 6))|length), 0 ]
  | "Part 1: \(.[0])\nPart 2: \(.[1])"
' <"${1:-input.txt}"
