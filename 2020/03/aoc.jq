#!/bin/sh
exec jq -r --slurp --raw-input '
def tree(m;x;y):
  if (m[y%(m|length)][x%(m[0]|length)] == "#") then 1 else 0 end;
def trees(m;x;y;sx;sy;a):
  if (y > (m|length)) then
    a
  else
    trees(m;x+sx;y+sy;sx;sy;(a+tree(m;x;y)))
  end;
. | split("\n")[:-1] |map(split("")) |
  . as $m |
  trees(.;0;0;3;1;0) as $p1 |
  [
   $p1,
   ([[1,1], [5,1], [7,1], [1,2]] |
    reduce .[] as $s ($p1; . * trees($m;0;0;$s[0];$s[1];0)))
  ] | "Part 1: \(.[0])\nPart 2: \(.[1])"' < ${1:-input.txt}
