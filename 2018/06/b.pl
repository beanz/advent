#!/usr/bin/perl
use warnings;
use strict;

use constant {
  X => 0,
  Y => 1,
};
my $d = <>;
chomp $d;
my @p;
my @min;
my @max;
while (<>) {
  chomp;
  my ($x, $y) = split /, /;
  push @p, [$x, $y];
  if (!defined $min[X] || $min[X] > $x) {
    $min[X] = $x;
  }
  if (!defined $max[X] || $max[X] < $x) {
    $max[X] = $x;
  }
  if (!defined $min[Y] || $min[Y] > $y) {
    $min[Y] = $y;
  }
  if (!defined $max[Y] || $max[Y] < $y) {
    $max[Y] = $y;
  }
}

sub md {
  my ($p1, $p2) = @_;
  return abs($p1->[0]-$p2->[0]) + abs($p1->[1]-$p2->[1]);
}

sub sd {
  my ($x, $y, $d) = @_;
  my $s = 0;
  for my $p (@p) {
    $s += md([$x,$y], $p);
  }
  return $s;
}

$b = sqrt $d;
my $a;
for my $y ($min[Y]-$b .. $max[Y]+$b) {
 LOOP:
  for my $x ($min[X]-$b .. $max[X]+$b) {
    my $in = sd($x, $y) < $d;
    $a++ if ($in);
  }
}
print $a, "\n";
