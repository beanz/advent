#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my ($r, $u) = @$in;
  my %rr;
  $rr{$_->[0],$_->[1]}++ for (@$r);
  my $p1 = 0;
  my $p2 = 0;
  for my $l (@$u) {
    my @g = sort {$rr{$a, $b} ? -1 : 1} @$l;
    my $m = $g[int(@g / 2)];
    if ("@g" eq "@$l") {
      $p1 += $m;
    } else {
      $p2 += $m;
    }
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
