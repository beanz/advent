#!/bin/sh

F="aoc.pl cpp/aoc.cpp aoc.zig aoc.cr aoc.nim main.go"
for d in ????/?? ; do
  if [ ! -e $d/input.txt ]; then
    continue
  fi
  for f in $F; do
    test -f $d/$f || echo $d/$f missing
  done
  Y=${d%/*}
  D=${d#*/}
  R=aoc-rust/src/bin/aoc-$Y-$D.rs
  test -f $R || echo $R missing
done
