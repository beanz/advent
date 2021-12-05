#!/bin/sh

exec jq -r --raw-input --slurp \
   'def fuel(x): ((x/3)|floor) - 2;
    def fuelr(x): fuel(x) as $f | if ($f > 0) then $f + fuelr($f) else 0 end;
    . | split("\n")[:-1] | map(tonumber) |
    {
      p1: [fuel(.[])] | add,
      p2: [fuelr(.[])] | add
    } | "Part 1: \(.p1)\nPart 2: \(.p2)"' < ${1:-input.txt}
