#!/bin/sh
exec jq -r --slurp --raw-input '
def run(hh):
  (hh.code|length) as $l |
  hh.ip as $ip |
  hh.seen as $seen |
  if (($seen | index($ip) != null) or ($ip >= $l)) then
    [hh.acc, $ip]
  else
    hh.code as $code |
    $code[hh.ip] as $inst |
    (hh.seen + [hh.ip]) as $nseen |
    hh |
      if ($inst[0] == "acc") then
         (.ip + 1) as $nip |
         (.acc + $inst[1]) as $nacc |
         { code: $code, acc: $nacc, ip: $nip, seen: $nseen } |
         run(.)
      elif ($inst[0] == "jmp") then
         (.ip + $inst[1]) as $nip |
         (.acc) as $nacc |
         { code: $code, acc: $nacc, ip: $nip, seen: $nseen } |
         run(.)
      else
         (.ip + 1) as $nip |
         { code: $code, acc: hh.acc, ip: $nip, seen: $nseen } |
         run(.)
      end
    end;
def run2(code):
  code as $code |
  (code |length) as $l |
  reduce range(0; $l) as $i
    ([]; if ((.|length) > 0) then
           .
         else
           (. +
            (
            $code |
            nth($i-1) |= (if .[0] == "jmp" then ["nop",.[1]] else
                        if .[0] == "nop" then ["jmp",.[1]] else
                        . end end) |
            run({code: ., acc: 0, ip: 0, seen: []}) as $res |
            if $res[1] >= $l then [$res[0]] else [] end
            )
           )
         end);
. | .[:-1] | split("\n")
  | map(split(" ") | .[1] = (.[1] | tonumber))
  | [
     run({code: ., acc: 0, ip: 0, seen: []})[0],
     run2(.)[0]
    ] | "Part 1: \(.[0])\nPart 2: \(.[1])"'
