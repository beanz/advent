#!/bin/sh

fuel() {
  echo $(($1/3-2))
}

fuelr() {
  m=$1
  s=0
  while true ; do
    f=$(fuel $m)
    if [ $f -le 0 ]; then
      break
    fi
    s=$((s+f))
    m=$f
  done
  echo $s
}

total() {
  s=0
  while read i; do
    s=$((s+i))
  done
  echo $s
}

while read m ; do fuel $m ;done <input.txt | total
while read m ; do fuelr $m ;done <input.txt | total

