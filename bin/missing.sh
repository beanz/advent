#!/bin/sh

F="aoc.pl cpp/aoc.cpp aoc.zig aoc.cr aoc.nim main.go"
for d in ????/?? ; do
  for f in $F; do
    test -f $d/$f || echo $d/$f missing
  done
done
