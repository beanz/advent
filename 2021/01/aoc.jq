#!/bin/sh

exec jq -L../../lib-jq -r --slurp '
  include "window";
  { p1: [window(.[]; 2; 1) | select(.[0] < .[1])] | length,
    p2: [window(.[]; 3; 1) | add ]| [window(.[]; 2; 1) | select(.[0] < .[1])] | length,
  } | "Part 1: \(.p1)\nPart 2: \(.p2)"'
