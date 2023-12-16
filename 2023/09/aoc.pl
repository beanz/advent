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
my @pascal = ([1], [1, 1]);
for my $r (2 .. 22) {
  my @row = (1);
  for my $c (1 .. $r - 1) {
    push @row, ($pascal[$r - 1]->[$c - 1]) + ($pascal[$r - 1]->[$c]);
  }
  push @row, 1;
  push @pascal, \@row;
}

#my $reader = \&read_stuff;
my $reader = \&read_guess;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m = (lines => $in);
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    print "$i: $l\n";
  }
  return \%m;
}

sub solve {
  my ($in) = @_;
  my $l = @$in;
  my $m = 1;
  my ($s1, $s2) = (0, 0);
  for my $i (0 .. $l - 1) {
    my $tm = $pascal[$l]->[$i + 1] * $m;
    $s1 += $tm * $in->[$l - 1 - $i];
    $s2 += $tm * $in->[$i];
    $m *= -1;
  }
  return [$s1, $s2];
}

sub calc {
  my ($in) = @_;
  my @r;
  for (@$in) {
    my $s = solve($_);
    $r[0] += $s->[0];
    $r[1] += $s->[1];
  }
  return \@r;
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $r = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$r;
