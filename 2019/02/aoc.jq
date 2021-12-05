#!/bin/sh

exec jq -r --raw-input --slurp \
   'def run(c):
      if c.prog[c.ip] == 1 then
        (c.ip+4) as $nip |
        c.prog[(c.ip+3)] as $o |
        c.prog[(c.ip+1)] as $i1 |
        c.prog[(c.ip+2)] as $i2 |
        c.prog[$i1] as $v1 |
        c.prog[$i2] as $v2 |
        c.prog | nth($o) |= $v1+$v2 | run({ip: $nip, prog: c.prog})
      elif c.prog[c.ip] == 2 then
        (c.ip+4) as $nip |
        c.prog[(c.ip+3)] as $o |
        c.prog[(c.ip+1)] as $i1 |
        c.prog[(c.ip+2)] as $i2 |
        c.prog[$i1] as $v1 |
        c.prog[$i2] as $v2 |
        c.prog | nth($o) |= $v1*$v2 | run({ip: $nip, prog: c.prog})
      else
        c.prog | first
      end;
    def srun(s):
       s.prog as $saved |
       (s.input/100 | floor) as $n1 |
       (s.input%100) as $n2 |
       s.prog | nth(1) |= $n1 | nth(2) |= $n2 |
       if run({ip: 0, prog: .}) == 19690720 then
         s.input
       else
         (s.input+1) as $ninput |
         srun({input: $ninput, prog: $saved})
       end;
    . | split(",") | map(tonumber) |
    {
       p1: (nth(1) |= 12 | nth(2) |= 2 | run({ip: 0, prog: .})),
       p2: srun({input: 0, prog: .})
    } | "Part 1: \(.p1)\nPart 2: \(.p2)"' < ${1:-input.txt}
