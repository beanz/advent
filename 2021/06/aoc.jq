#!/bin/sh

jq -L../../lib-jq -r --slurp --raw-input '
def days(fish;n): reduce range(0;n) as $i (fish;[fish[1],fish[2],fish[3],fish[4],fish[5],fish[6],fish[0]+fish[7],fish[8],fish[0]]);
.[:-1]|split(",") |map(tonumber)| reduce .[] as $f ([0,0,0,0,0,0,0,0,0]; .[$f]+=1)| days(.;80) | "Part 1: \(.|add)\nPart 2: \(days(.;176)|add)"
' < ${1:-input.txt}
