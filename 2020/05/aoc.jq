#!/bin/sh
exec jq -r --slurp --raw-input '
. | split("\n")[:-1]
  | map(split("")
        | map(if . == "B" or . == "R" then 1 else 0 end)
        | reduce .[] as $bin (0; (. * 2) + $bin))
  | [
     (. | max),
     (. |max) as $max
      | (. | min) as $min
      | (($min+$max)*(1+$max-$min)/2) as $expected_sum
      | (. | reduce .[] as $e ($expected_sum; . - $e))
    ] | "Part 1: \(.[0])\nPart 2: \(.[1])"'
