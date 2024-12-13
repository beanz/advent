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

use constant {
  A => 0,
  B => 1,
  P => 2,
};

sub read_stuff {
  my $file = shift;
  my $in = read_chunks($file);
  my @a;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my @n = $l =~ /(\d+)/mg;
    push @a, [[$n[0], $n[1]], [$n[2], $n[3]], [$n[4], $n[5]]];
  }
  return \@a;
}

sub calc {
  my ($in) = @_;
  my ($p1, $p2) = (0, 0);
  my $ADD = 10000000000000;
  for (@$in) {
    $p1 += cost(@{$_->[0]}, @{$_->[1]}, @{$_->[2]});
    $p2 += cost(@{$_->[0]}, @{$_->[1]}, @{$_->[2]}, $ADD);
  }
  return [$p1, $p2];
}

sub cost {
  my ($ax, $ay, $bx, $by, $px, $py, $add) = @_;
  $add //= 0;
  $px += $add;
  $py += $add;
  my $d = $ax * $by - $ay * $bx;
  return 0 if ($d == 0);
  my $x = $px * $by - $py * $bx;
  my $m = int($x / $d);
  return 0 if ($m * $d != $x);
  $x = ($py - $ay * $m);
  my $n = int($x / $by);
  return 0 if ($n * $by != $x);
  return 3 * $m + $n;
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
