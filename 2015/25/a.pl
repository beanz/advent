#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
};

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
