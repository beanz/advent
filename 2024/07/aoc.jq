#!/bin/sh
exec jq -r --slurp --raw-input '
  def p1(nums; subtotal; total; p2):
    if subtotal > total then
      false
    elif (nums|length) == 0 then
      subtotal == total
    elif p1(nums[1:]; subtotal+nums[0]; total; p2) then
      true
    elif p1(nums[1:]; subtotal*nums[0]; total; p2) then
      true
    elif p2|not then
      false
    elif p1(nums[1:]; (((subtotal|tostring)+(nums[0]|tostring))|tonumber); total; p2) then
      true
    else
      false
    end;
  split("\n")[:-1] | map(split(":? ";"") |map(tonumber))
  | (map(if p1(.[2:]; .[1]; .[0]; false) then
            [.[0],.[0]]
          elif p1(.[2:]; .[1]; .[0]; true) then
            [0,.[0]]
          else
            [0,0]
          end)|reduce .[] as $i ([0,0]; [.[0]+$i[0],.[1]+$i[1]]))
  | "Part 1: \(.[0])\nPart 2: \(.[1])"
' <"${1:-input.txt}"
