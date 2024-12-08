#!/bin/sh

dir=$(readlink -m ${0%/*})/..
cd $dir
F="aoc.pl aoc.raku cpp/aoc.cpp aoc.zig aoc.cr aoc.nim main.go aoc.jq aoc.exs TC.txt"
for d in ????/?? ; do
  if [ ! -e $d/input.txt ]; then
    continue
  fi
  Y=${d%/*}
  D=${d#*/}
  for f in $F; do
    a="$(echo "${Y}"/*/$f)"
    if [ -f "${a%% *}" ]; then
      test -f $d/$f || echo $d/$f missing
    fi
  done
  a="$(echo aoc-rust/src/bin/aoc-"${Y}"-??.rs)"
  if [ -f "${a%% *}" ]; then
    R=aoc-rust/src/bin/aoc-$Y-$D.rs
    test -f $R || echo $R missing
  fi
done
