#!/bin/sh
exec jq -r --slurp --raw-input '
  split("\n")[:-1] | map(split(" +";"") | map(tonumber)) | transpose
  | [(.[0]|sort), (.[1]|sort)]
  | [
     (.|transpose|reduce .[] as $p (0; . + (($p[0]-$p[1])|length))),
     (.[1] as $r 
      |reduce .[0][] as $l (0;
         . + ($l * ([$r[]|select(. == $l)]|length))))
    ]
  | "Part 1: \(.[0])\nPart 2: \(.[1])"
' <"${1:-input.txt}"
