#!/bin/sh
exec jq -L../../lib-jq -r --slurp --raw-input '
  include "util";
  def safe: (inside([1,2,3])) or (inside([-1,-2,-3]));
  split("\n")[:-1] | map(split(" ") | map(tonumber))
  | [
      (map(select(diffs|safe))|length),
      (map(select(all_drop_one|any(diffs|safe)))|length)
    ]
  | "Part 1: \(.[0])\nPart 2: \(.[1])"
' <"${1:-input.txt}"
