#!/bin/sh
exec jq -L../../lib-jq -r --slurp --raw-input '
def fuel(a;b): a-b | if . < 0 then -. else . end;
def fuel2(a;b): fuel(a;b) | .*(1+.)/2;
split(",") |map(tonumber) |
  (.|sort) as $hp | {
    p1: [$hp[] | fuel($hp[($hp|length)/2];.)]|add,
    p2: ((.|add/length|floor) as $mean |
         [[$mean,$mean+1][] | . as $s | [$hp[] | fuel2($s;.)]|add] | min)
  } | "Part 1: \(.p1)\nPart 2: \(.p2)"
' < ${1:-input.txt}
