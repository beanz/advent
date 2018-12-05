#!/usr/bin/perl -l

@a=<>;
for (@a) {
  m/@\s*(\d+),(\d+):\s+(\d+)x(\d+)/;
  for my$i($1..$1+$3-1){
    for my$j($2..$2+$4-1){
      $k=$i."!".$j;$c{$k}++;
    }
  }
}
for (@a) {
  $g=1;
  m/#(\d+)\s+@\s*(\d+),(\d+):\s+(\d+)x(\d+)/;
  for my$i($2..$2+$4-1){
    for my$j($3..$3+$5-1){
      undef $g if ($c{$i."!".$j} != 1)
    }
  }
  print $1 if ($g);
}
