#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

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

if (TEST) {
  assertEq("paper('2x3x4')", paper("2x3x4"), 58);
  assertEq("paper('1x1x10')", paper("1x1x10"), 43);
}

sub ribbon {
  my $d = shift;
  my @d = sort { $a <=> $b } split /x/, $d;
  return 2*($d[0]+$d[1]) + product(@d);
}

if (TEST) {
  assertEq("ribbon('2x3x4')", ribbon("2x3x4"), 34);
  assertEq("ribbon('1x1x10')", ribbon("1x1x10"), 14);
}

my @i = @{read_lines(shift//"input.txt")};
my $area = 0;
my $ribbon = 0;
for my $d (@i) {
  $area += paper($d);
  $ribbon += ribbon($d);
}

print "Part 1: ", $area, "\n";
print "Part 2: ", $ribbon, "\n";
