#!/bin/sh
exec jq -r --slurp --raw-input '
  def part1:
    [match("mul\\((\\d+),(\\d+)\\)"; "g")|.captures|map(.string|tonumber)]|map(.[0]*.[1])|add;
  [
    part1,
    (split("do()")|map(split("don'"'"'t()")|.[0]|part1)|add)
  ]
  | "Part 1: \(.[0])\nPart 2: \(.[1])"
' <"${1:-input.txt}"
