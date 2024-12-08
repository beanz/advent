#!/bin/sh
exec jq -L../../lib-jq -r --slurp --raw-input '
  include "map"; include "util";
  def bounds($w; $h; $x;$y): (0 <= $x and $x < $w and 0 <= $y and $y < $h);
  def part1($w; $h; $pairs):
    .[0][1] as $x1
    |.[0][2] as $y1
    |.[1][1] as $x2
    |.[1][2] as $y2
    |($x1-$x2) as $dx
    |($y1-$y2) as $dy
    |[$x1+$dx, $y1+$dy],[$x2-$dx, $y2-$dy]|select(bounds($w;$h;.[0];.[1]));
  def move($w;$h;$p;$d):
    $p|while(bounds($w;$h;.[0];.[1]); [.[0]+$d[0],.[1]+$d[1]]);
  def part2($w; $h; $pairs):
    .[0][1] as $x1
    |.[0][2] as $y1
    |.[1][1] as $x2
    |.[1][2] as $y2
    |($x1-$x2) as $dx
    |($y1-$y2) as $dy
    |(
      move($w;$h;[$x1,$y1];[$dx,$dy]),
      move($w;$h;[$x2, $y2];[-$dx,-$dy])
     );
  sparse_map | .w as $w | .h as $h |
  .m | group_by(.[0])
  | map(pairs)
  | [
     ((map(map(part1($w;$h;.)))|flatten(1)|unique)|length),
     ((map(map(part2($w;$h;.)))|flatten(1)|unique)|length)
    ]
  | "Part 1: \(.[0])\nPart 2: \(.[1])"
' <"${1:-input.txt}"
