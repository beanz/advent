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

my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @m = (map {[split /,\s+|\s@\s/, $_]} @$in);
  return \@m;
}
use constant {
  VX => 3,
  VY => 4,
  VZ => 5,
};

sub intersect {
  my ($a, $b) = @_;
  my $a1 = [$a->[X] + $a->[VX], $a->[Y] + $a->[VY]];
  my $b1 = [$b->[X] + $b->[VX], $b->[Y] + $b->[VY]];
  my $am = ($a1->[Y] - $a->[Y]) / ($a1->[X] - $a->[X]);
  my $bm = ($b1->[Y] - $b->[Y]) / ($b1->[X] - $b->[X]);
  my $ab = $a->[Y] - $am * $a->[X];
  my $bb = $b->[Y] - $bm * $b->[X];
  return if ($am == $bm);    # parallel
  my $px = ($bb - $ab) / ($am - $bm);
  my $py = $am * $px + $ab;
  return [$px, $py];
}

sub calc {
  my ($in) = @_;
  my $in_range = @$in < 20 ? sub { 7 <= $_[0] && $_[0] <= 27 } :
sub { 200000000000000 <= $_[0] && $_[0] <= 400000000000000 };
  my $p1 = 0;
  for my $i (0 .. @$in - 1) {
    for my $j ($i + 1 .. @$in - 1) {
      my $a = $in->[$i];
      my $b = $in->[$j];
      my $p = intersect($a, $b);
      if (defined $p) {
        my $in_x = $in_range->($p->[X]);
        my $in_y = $in_range->($p->[Y]);
        my $future_a = ($a->[VX] > 0 && $p->[X] > $a->[X]) || ($a->[VX] < 0 && $p->[X] < $a->[X]) ||($a->[VY] > 0 && $p->[Y] > $a->[Y]) || ($a->[VY] < 0 && $p->[Y] < $a->[Y]);
        my $future_b = ($b->[VX] > 0 && $p->[X] > $b->[X]) || ($b->[VX] < 0 && $p->[X] < $b->[X]) ||($b->[VY] > 0 && $p->[Y] > $b->[Y]) || ($b->[VY] < 0 && $p->[Y] < $b->[Y]);
        my $future = $future_a && $future_b;
        $p1++ if ($in_x && $in_y && $future);
      }
    }
  }
  my $p2 = 0;
  for my $i (0..2) {
    my $t = chr(ord('A')+$i);
    my $p = $in->[$i];
    print "x+X*$t=$p->[X]+$p->[VX]*$t\n";
    print "y+Y*$t=$p->[Y]+$p->[VY]*$t\n";
    print "z+Z*$t=$p->[Z]+$p->[VZ]*$t\n";
  }

  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
