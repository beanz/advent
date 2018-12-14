#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use List::Util qw/min product/;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
};

sub area {
  2*$_[0]*$_[1]
}

sub paper {
  my $d = shift;
  my ($w, $h, $l) = split /x/, $d;
  my $a1 = area($w, $h);
  my $a2 = area($h, $l);
  my $a3 = area($w, $l);
  my $as = min($a1/2, $a2/2, $a3/2);
  return $a1 + $a2 + $a3 + $as;
}

print paper("2x3x4"), " = 58\n";
print paper("1x1x10"), " = 43\n";

sub ribbon {
  my $d = shift;
  my @d = sort { $a <=> $b } split /x/, $d;
  return 2*($d[0]+$d[1]) + product(@d);
}

print ribbon("2x3x4"), " = 34\n";
print ribbon("1x1x10"), " = 13\n";

my @i = <>;
my $area = 0;
my $ribbon = 0;
for my $d (@i) {
  $area += paper($d);
  $ribbon += ribbon($d);
}

print "Part 1: ", $area, "\n";
print "Part 2: ", $ribbon, "\n";
