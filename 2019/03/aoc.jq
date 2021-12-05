#!/bin/sh

exec jq -r --raw-input --slurp \
   '
    def dx(dir):
      if (dir == "L") then
         -1
      elif (dir == "R") then
         1
      else
        0
      end;
    def dy(dir):
      if (dir == "U") then
         -1
      elif (dir == "D") then
         1
      else
        0
      end;
    def wire(w):
      def _wire:
        # [acc, x, y, steps, w]
        if .[4] | length == 0 then
           .[0]
        else
          .[4][0] as $first |
          .[4][1:] as $tail |
          dx($first) as $dx |
          dy($first) as $dy |
          (.[1]+$dx) as $nx |
          (.[2]+$dy) as $ny |
          (.[3]+1) as $nsteps |
            [.[0] + [[$nx, $ny, $nsteps]], $nx, $ny, $nsteps, $tail] | _wire
        end;
      w | [[], 0, 0, 0, [.[]]] | _wire | sort_by(.[2]) | unique_by([.[0],.[1]])
      ;
    def wirepart(w):
       w |
       {
         d: split("")[0],
         c: sub("^.";"") | tonumber
       } | [.c as $count | .d as $dir | range(0;$count) | $dir ]
      ;
     def abs(x):
       if x < 0 then -x else x end;
     def mdist(x): (abs(x[0]) + abs(x[1]));
     def intersection(x;y):
       ( (x|unique) + (y|unique) | sort) as $sorted
       | reduce range(1; $sorted|length) as $i
         ([]; if $sorted[$i][0] == $sorted[$i-1][0] and
                 $sorted[$i][1] == $sorted[$i-1][1]
              then
                ($sorted[$i][2] + $sorted[$i-1][2]) as $totalsteps |
                mdist([$sorted[$i][0], $sorted[$i][1]]) as $mdist |
                . + [[$sorted[$i][0], $sorted[$i][1], $totalsteps, $mdist]]
              else
                .
              end);
    . | split("\n")[:-1] | { w1: nth(0) | split(",") |
                      [wirepart(.[])] | flatten | wire(.),
                w2: nth(1) | split(",") |
                      [wirepart(.[])] | flatten | wire(.),
       } | intersection(.w1;.w2) |
    {
       part1: min_by(.[3]) | .[3],
       part2: min_by(.[2]) | .[2],
    } | "Part 1: \(.part1)\nPart 2: \(.part2)"' < ${1:-input.txt}
