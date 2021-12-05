#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my %c;
my $s;
for (@{[@i]}) {
  m/@\s*(\d+),(\d+):\s+(\d+)x(\d+)/;
  for my$i($1..$1+$3-1){
    for my$j($2..$2+$4-1){
      my $k=$i."!".$j;
      $c{$k}++;
      $s++ if ($c{$k} == 2);
    }
  }
}

print 'Part 1: ', $s,"\n";

%c = ();
for (@i) {
  m/@\s*(\d+),(\d+):\s+(\d+)x(\d+)/;
  for my$i($1..$1+$3-1){
    for my$j($2..$2+$4-1){
      my $k=$i."!".$j;$c{$k}++;
    }
  }
}
for (@i) {
  my $g=1;
  m/#(\d+)\s+@\s*(\d+),(\d+):\s+(\d+)x(\d+)/;
  for my$i($2..$2+$4-1){
    for my$j($3..$3+$5-1){
      undef $g if ($c{$i."!".$j} != 1)
    }
  }
  if ($g) {
    print 'Part 2: ', $1, "\n";
    exit;
  }
}

