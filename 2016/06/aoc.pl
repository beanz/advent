#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use List::Util qw/min/;
my %c;
my @max;
while (<>) {
  chomp;
  my $i = 0;
  for my $c (split//) {
    my $count = $c{$i}->{$c}++;
    if (!exists $c{$i}->{max} || $count > $c{$i}->{max}) {
      $max[$i] = $c;
      $c{$i}->{max} = $count;
    }
    $i++;
  }
}
print "Part 1: ", (join '', @max), "\n";
print "Part 2: ",
  (join '',
   map {
     (sort { $c{$_}->{$a} <=> $c{$_}->{$b} } keys %{$c{$_}})[0]
   } sort { $a <=> $b } keys %c), "\n";
