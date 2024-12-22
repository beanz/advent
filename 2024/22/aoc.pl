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

#my $reader = \&read_stuff;
my $reader = \&read_2024;
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

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my %p2;
  for my $n (@$in) {
    my $prev = $n % 10;
    my @prices;
    for my $i (1 .. 2000) {
      $n ^= $n * 64;
      $n %= 16777216;
      $n ^= int($n / 32);
      $n %= 16777216;
      $n ^= $n * 2048;
      $n %= 16777216;
      my $price = $n % 10;
      push @prices, [$price, $prev - $price];
      $prev = $price;
    }
    my %seen;
    for my $j (0 .. @prices - 5) {
      my $price = $prices[$j + 3][0];
      my $k = join ',', map {$prices[$j + $_][1]} (0 .. 3);
      next if ($seen{$k});
      $seen{$k}++;
      $p2{$k} += $price;
    }
    $p1 += $n;
  }
  return [$p1, max values %p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
