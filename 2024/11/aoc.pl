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
  return [split /\s+/, $in->[0]];
}

sub blinks {
  state %b;
  my ($s, $n) = @_;
  if ($n == 0) {
    return 1;
  }
  if (exists $b{$s, $n}) {
    return $b{$s, $n};
  }
  my $l = length $s;
  my $res;
  my $nn = $n - 1;
  if ($s == 0) {
    print STDERR " => 1\n" if DEBUG;
    $res = blinks(1, $nn);
  } elsif ($l % 2 == 0) {
    my $a = substr $s, 0, ($l / 2);
    my $b = 0 + substr $s, ($l / 2);
    print STDERR " => $a, $b\n" if DEBUG;
    my $resA = blinks($a, $nn);
    print STDERR " RA: $a, $nn == ", ($resA // "?"), "\n" if DEBUG;
    my $resB = blinks($b, $nn);
    print STDERR "RB: $b, $nn == ", ($resB // "?"), "\n" if DEBUG;
    $res = $resA + $resB;
  } else {
    print STDERR " => ", $s * 2024, "\n" if DEBUG;
    my $a = $s * 2024;
    $res = blinks($a, $nn);
  }
  $b{$s, $n} = $res;
  return $res;
}

sub calc {
  my ($in) = @_;
  my @s = @$in;
  my $p1 = sum(map {blinks($_, 25)} @s);
  my $p2 = sum(map {blinks($_, 75)} @s);
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
