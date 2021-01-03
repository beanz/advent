#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

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
