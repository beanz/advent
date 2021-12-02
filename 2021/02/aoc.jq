#!/bin/sh

exec jq -L../../lib-jq -r --slurp --raw-input '
   split("\n")[:-1] |map(split(" ")| [(.[0]|split(""))[0], (.[1]|tonumber)]) |
  (reduce .[] as $cmd (
    [0,0,0,0];
    if $cmd[0] == "f" then
      [.[0]+$cmd[1], .[1], .[2]+($cmd[1]*.[3]), .[3]]
    elif $cmd[0] == "u" then
      [.[0], .[1]-$cmd[1], .[2], .[3]-$cmd[1]]
    else
      [.[0], .[1]+$cmd[1], .[2], .[3]+$cmd[1]]
    end)) |
    { p1 : (.[0] * .[1]), p2 : (.[0] * .[2]) }
    | "Part 1: \(.p1)\nPart 2: \(.p2)"'
