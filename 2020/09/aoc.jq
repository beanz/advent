#!/bin/sh
pre=${1:-25}
exec jq -r --slurp --raw-input '
def comb(n;k):
  n as $n | k as $k |
  [range(0;$n)] |
  [combinations($k)]|map(unique) |map(select(. | length == $k))|unique;
def sums(l;i;comb): l as $l | i as $i | comb as $comb |
  reduce $comb[] as $c ([]; . + [[$l[$i-$c[0]-1], $l[$i-$c[1]-1]]|add]);
def part1(in):
  .[0] as $l | .[1] as $pre | comb($pre;2) as $comb |
  reduce range($pre;($l|length)) as $i
   ([];
    . + ($l[$i] as $e |
         sums($l;$i;$comb) |
         (if (.|map(select(. == $e)) | length != 0) then [] else [$e] end)
        )
   ) |
  first;
def part2(in): in[0] as $l | in[1] as $tgt | in[2] as $s | in[3] as $e |
  in[4] as $subsetsum |
  if ($subsetsum == $tgt and $s != ($e-1)) then
    ($l[$s:$e] | (.|min) + (.|max))
  else
    if ($subsetsum < $tgt) then
      part2([$l, $tgt, $s, ($e+1), ($subsetsum + $l[$e])])
    else
      part2([$l, $tgt, ($s+1), $e, ($subsetsum - $l[$s])])
    end
  end;
. | .[:-1] | split("\n") | map(tonumber) |
  [ ., '$pre' ] |
  [.[0], part1(.)] |
  [.[1], part2([.[0], .[1], 0, 2, ((.[0])[0:2]|add)])] |
  "Part 1: \(.[0])\nPart 2: \(.[1])"'
