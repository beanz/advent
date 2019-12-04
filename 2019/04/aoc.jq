#!/bin/sh

exec jq -r --raw-input --slurp \
   'def part1(r):
        range(r[0];r[1]+1) | tostring |
        select((. | length) == 6) |
        select(. | test("(.)\\1")) |
        split("") |
        select(.[0] <= .[1] and
               .[1] <= .[2] and
               .[2] <= .[3] and
               .[3] <= .[4] and
               .[4] <= .[5]);
    def part2(r):
        range(r[0];r[1]+1) | tostring |
        select((. | length) == 6) |
        select(. | test("^(?:.*(.)((?!\\1).)\\2(?!\\2)|(.)\\3(?!\\3))")) |
        split("") |
        select(.[0] <= .[1] and
               .[1] <= .[2] and
               .[2] <= .[3] and
               .[3] <= .[4] and
               .[4] <= .[5]);
    . | split("-") | map(tonumber) |
    {
       p1: [part1(.)] | length,
       p2: [part2(.)] | length
    } | "Part 1: \(.p1)\nPart 2: \(.p2)"'
