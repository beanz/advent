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

my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

use constant {
  DX => [0, 1, 0, -1],
  DY => [-1, 0, 1, 0],
};

sub get {
  my ($in, $x, $y) = @_;
  my $i = $in->index($x, $y) // return -1;
  return ord($in->get($x, $y)) - ord('0');
}

sub score {
  my ($in, $sx, $sy) = @_;
  my @todo = [$sx, $sy, 0];
  my %seen;
  my $score = 0;
  while (@todo) {
    my $cur = shift @todo;
    next if (exists $seen{$cur->[X] . ',' . $cur->[Y]});
    $seen{$cur->[X] . ',' . $cur->[Y]}++;
    if ($cur->[Z] == 9) {
      $score++;
      next;
    }
    for (0 .. 3) {
      my ($nx, $ny) = ($cur->[X] + DX->[$_], $cur->[Y] + DY->[$_]);
      if (get($in, $nx, $ny) == $cur->[Z] + 1) {
        push @todo, [$nx, $ny, $cur->[Z] + 1];
      }
    }
  }
  return $score;
}

sub rank {
  my ($in, $sx, $sy, $sz) = @_;
  $sz //= 0;
  my $rank = 0;
  if ($sz == 9) {
    return 1;
  }
  for (0 .. 3) {
    my ($nx, $ny) = ($sx + DX->[$_], $sy + DY->[$_]);
    if (get($in, $nx, $ny) == $sz + 1) {
      $rank += rank($in, $nx, $ny, $sz + 1);
    }
  }
  return $rank;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  for my $y (0 .. $in->height - 1) {
    for my $x (0 .. $in->width - 1) {

      #print "$x,$y,",get($in, $x, $y), "\n";
      next unless (get($in, $x, $y) == 0);
      $p1 += score($in, $x, $y);
      $p2 += rank($in, $x, $y);
    }
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
