#!/usr/bin/perl -ln
m/@\s*(\d+),(\d+):\s+(\d+)x(\d+)/;
for my$i($1..$1+$3-1){
  for my$j($2..$2+$4-1){
    $k=$i."!".$j;
    $c{$k}++;
    $s++ if ($c{$k} == 2);
  }
}

END{print$s}

