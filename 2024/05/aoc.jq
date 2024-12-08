#!/bin/sh
exec jq -L../../lib-jq -r --slurp --raw-input '
  include "util";
  def ints: .|map(split("[^0-9]+";"")|map(tonumber));
  def has_rule($r;$a;$b): $r | index([[$a,$b]]);
  def rulesort($r;$l):
    $l |
    if length < 2 then
      .
    else .[0] as $p
      | reduce del(.[0])[] as $x
        ([[],[]];
         if has_rule($r; $p; $x) then
           .[1] += [$x]
         else
           .[0] += [$x]
         end)
      | rulesort($r;.[0]) + [$p] + rulesort($r;.[1])
    end;
  split("\n\n")
  | (.[0]|split("\n")|ints) as $r
  | .[1]|split("\n")[:-1]|ints
  | map(. as $before|rulesort($r; .) as $after|
      if ($before == $after) then
        [($before|mid), 0]
      else
        [0, ($after|mid)]
      end)
  | reduce .[] as $i ([0,0]; [.[0]+$i[0], .[1]+$i[1]])
  | "Part 1: \(.[0])\nPart 2: \(.[1])"
' <"${1:-input.txt}"
