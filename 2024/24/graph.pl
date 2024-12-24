#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

my %c = (AND => 'blue', OR => 'green', XOR => 'black');
print "digraph aoc2024day24 {\n";
while (<>) {
  next unless (/^(\w+) (\w+) (\w+) -> (\w+)$/);
  print qq{  $4 -> $1 [label="$2",color=$c{$2}]\n};
  print qq{  $4 -> $3 [label="$2",color=$c{$2}]\n};
}
print "  z05 [color=red]\n";
print "  z11 [color=red]\n";
print "  z23 [color=red]\n";
print "  frt [color=red]\n";
print "  sps [color=red]\n";
print "  tst [color=red]\n";
print "  pmd [style=filled,fillcolor=green]\n";
print "  cgh [style=filled,fillcolor=green]\n";
print "}\n";

