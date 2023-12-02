#!/bin/sh
exec jq -r --slurp --raw-input '
  split("\n")[:-1] | 
  map(
    split("[;,:]? ";"") | 
    {
     id: .[1]|tonumber,
     sets: (
       .[2:]| [recurse(.[2:];length>1)[0:2]|reverse] |
       reduce .[] as $p ({}; .[$p[0]] = ([.[$p[0]], ($p[1]|tonumber)] | max))
      )
    } |
    [
     .,
     if .sets.red <= 12 and .sets.green <= 13 and .sets.blue <= 14 then .id else 0 end,
     .sets.red*.sets.green*.sets.blue
    ]
  )
  | [.,  (.|map(.[1])|add), (.|map(.[2])|add)]
  | "Part 1: \(.[1])\nPart 2: \(.[2])"
' <"${1:-input.txt}"
