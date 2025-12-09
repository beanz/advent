#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  for my $i (0 .. @$in - 1) {
  LOOP:
    for my $j ($i + 1 .. @$in - 1) {
      my $dx = 1 + abs($in->[$i]->[0] - $in->[$j]->[0]);
      my $dy = 1 + abs($in->[$i]->[1] - $in->[$j]->[1]);
      my $a = $dx * $dy;
      $p1 = max($p1, $a);

      if ($p2 > $a) {
        next LOOP;
      }
      my $mnx = min($in->[$i]->[0], $in->[$j]->[0]);
      my $mxx = max($in->[$i]->[0], $in->[$j]->[0]);
      my $mny = min($in->[$i]->[1], $in->[$j]->[1]);
      my $mxy = max($in->[$i]->[1], $in->[$j]->[1]);

      for my $k (0 .. @$in - 1) {
        next if ($k == $i || $k == $j);
        my ($x1, $y1) = @{$in->[$k]};
        my $l = ($k + 1) % @$in;
        next if ($l == $i || $l == $j);
        my ($x2, $y2) = @{$in->[$l]};
        my $mnxl = min($x1, $x2);
        my $mxxl = max($x1, $x2);
        my $mnyl = min($y1, $y2);
        my $mxyl = max($y1, $y2);

        unless ($mxxl <= $mnx
          || $mxx <= $mnxl
          || $mxyl <= $mny
          || $mxy <= $mnyl)
        {
          next LOOP;
        }
      }
      $p2 = $a;
    }
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
