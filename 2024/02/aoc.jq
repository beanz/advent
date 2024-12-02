#!/bin/sh
exec jq -r --slurp --raw-input '
  def safe: (inside([1,2,3])) or (inside([-1,-2,-3]));
  def diffs: [ .[0:-1], .[1:] ] | transpose | map (.[0]-.[1]);
  def all_drop_one: [. as $l|range(0;(.|length)) as $i |($l|del(.[$i]))];
  split("\n")[:-1] | map(split(" ") | map(tonumber))
  | [
      (map(select(diffs|safe))|length),
      (map(select(all_drop_one|any(diffs|safe)))|length)
    ]
  | "Part 1: \(.[0])\nPart 2: \(.[1])"
' <"${1:-input.txt}"
