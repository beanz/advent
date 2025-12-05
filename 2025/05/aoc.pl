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
  my $in = read_2024($file);
  $in->[0] =
    [sort {$a->[0] <=> $b->[0]} map {[$_->[0], 1 + $_->[1]]} @{$in->[0]}];
  return $in;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $ranges = $in->[0];
  $in = $in->[1];
  for my $l (@$in) {
    for my $r (@$ranges) {
      if ($r->[0] <= $l && $l < $r->[1]) {
        $p1++;
        last;
      }
    }
  }
  my @r = shift @$ranges;
  for my $r (@$ranges) {
    my ($s, $e) = @$r;
    if ($s > $r[$#r][1]) {
      push @r, [$s, $e];
    } else {
      $r[$#r][1] = max($e, $r[$#r][1]);
    }
  }
  my $p2 = sum(map {$_->[1] - $_->[0]} @r);
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
