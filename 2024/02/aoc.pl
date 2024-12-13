#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

#use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub dec {
  my ($a) = shift;
  for (0 .. scalar @$a - 2) {
    if ($a->[$_] <= $a->[$_ + 1]) {
      return 0;
    }
  }
  return 1;
}

sub inc {
  my ($a) = shift;
  for (0 .. scalar @$a - 2) {
    if ($a->[$_] >= $a->[$_ + 1]) {
      return 0;
    }
  }
  return 1;
}

sub restrict {
  my ($a) = shift;
  for (0 .. scalar @$a - 2) {
    my $d = abs($a->[$_] - $a->[$_ + 1]);
    if ($d > 3 || $d < 1) {
      return 0;
    }
  }
  return 1;
}

sub part2 {
  my ($a) = shift;
  my @c = combinations($a, scalar @$a - 1);
  for my $l (@c) {
    return 1 if (restrict($l) && (dec($l) || inc($l)));
  }
  return 0;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  for my $l (@$in) {
    if (restrict($l) && (dec($l) || inc($l))) {
      $p1++;
      $p2++;
    } else {
      $p2++ if (part2($l));
    }
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
