#!/bin/sh

exec jq -r --slurp '
  { p1: (first(combinations(3) |
           select(.[0] + .[1] ==2020)) | .[0] * .[1]),
    p2: (first(combinations(3) |
           select(.[0] + .[1] + .[2] ==2020)) | .[0] * .[1] * .[2])
  } | "Part 1: \(.p1)\nPart 2: \(.p2)"'
