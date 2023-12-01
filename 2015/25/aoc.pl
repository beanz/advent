#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

sub sumseries {
  $_[0]*($_[0]+1)/2
}

sub pos2index {
  my ($x, $y) = @_;
  return ($y*($x-1)) + sumseries($x-2) + sumseries($y);
}

sub expmod {
  my($a, $b, $n) = @_;
  my $c = 1;
  do {
    ($c *= $a) %= $n if $b % 2;
    ($a *= $a) %= $n;
  } while ($b = int $b/2);
  $c;
}

sub seq {
  (20151125 * expmod(252533, $_[0]-1, 33554393)) % 33554393;
}

print 'Part 1: ', seq(pos2index(2947, 3029)), "\n";
