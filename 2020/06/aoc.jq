#!/bin/sh
exec jq -r --slurp --raw-input '
. | .[:-1] | split("\n\n")
  | [.[] | split("\n") ]
  | map(map(split("")))
  | [
     (. | map(flatten) | map(unique) | flatten | length ),
     (. |
      map(
        (. | length) as $n
        | (. | flatten) as $a
        | ($a | unique) as $l
        | reduce $l[] as $ch ([]; . + [($a | map(.|select(. == $ch))|length)|select(. == $n)])|length
        )|add
     )
    ] | "Part 1: \(.[0])\nPart 2: \(.[1])"' < ${1:-input.txt}
