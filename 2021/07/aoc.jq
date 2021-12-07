#!/bin/sh
exec jq -L../../lib-jq -r --slurp --raw-input '
def fuel(a;b): a-b | if . < 0 then -. else . end;
def fuel2(a;b): a-b | if . < 0 then -. else . end| .*(1+.)/2;
split(",") |map(tonumber) |
  . as $hp | {
    p1: [range((.|min);(.|max)) | . as $s | [$hp[] | fuel($s;.)]|add ] | min,
    p2: [range((.|min);(.|max)) | . as $s | [$hp[] | fuel2($s;.)]|add ] | min
  } | "Part 1: \(.p1)\nPart 2: \(.p2)"
' < ${1:-input.txt}
