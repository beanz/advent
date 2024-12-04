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

my $reader = \&read_slurp;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  my @s = ($in =~ m/(mul\(\d+,\d+\)|do\(\)|don't\(\))/mg);
  my $do = 1;
  for my $m (@s) {
    if ($m =~ m/mul\((\d+),(\d+)\)/) {
      $p1 += $1 * $2;
      $p2 += $do * $1 * $2;
    } elsif ($m eq 'do()') {
      $do = 1;
    } else {
      $do = 0;
    }
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
