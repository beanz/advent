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

sub sums {
  my ($v) = @_;
  my $s = pop @$v;
  unless (@$v) {
    return $s;
  }
  my @a;
  for (sums([@$v])) {
    push @a, $s + $_;
    push @a, $s * $_;
  }
  return @a;
}

sub sums2 {
  my ($v) = @_;
  my $s = pop @$v;
  unless (@$v) {
    return $s;
  }
  my @a;
  for (sums2([@$v])) {
    push @a, $s + $_;
    push @a, $s * $_;
    push @a, $_ . $s;
  }
  return @a;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
LINE:
  for my $l (@$in) {
    my $t = shift @$l;
    for (sums([@$l])) {
      if ($t == $_) {
        $p1 += $t;
        $p2 += $t;
        next LINE;
      }
    }
    for (sums2($l)) {
      if ($t == $_) {
        $p2 += $t;
        next LINE;
      }
    }
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
