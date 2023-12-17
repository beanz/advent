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

use constant {
  NORTH => 1,
  SOUTH => 2,
  EAST => 4,
  WEST => 8,
  START => 16,
  COUNT => 2,
};

my $file = shift // "input.txt";

my %mt = (
  '.' => 0,
  '|' => NORTH | SOUTH,
  '-' => EAST | WEST,
  'L' => NORTH | EAST,
  'J' => NORTH | WEST,
  '7' => SOUTH | WEST,
  'F' => SOUTH | EAST,
  'S' => START,
);

my %rmt = reverse %mt;

my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m;
  my $y = 0;
  for (@$in) {
    my @r;
    my $x = 0;
    for (split //) {
      push @r, $mt{$_};
      if ($_ eq 'S') {
        $m{s} = [$x, $y];
      }
      $x++;
    }
    push @{$m{m}}, \@r;
    $y++;
  }
  $m{w} = length $in->[0];
  $m{h} = @$in;
  return \%m;
}

sub calc {
  my ($in) = @_;
  my $c = 0;
  my ($x, $y) = @{$in->{s}};
  my $t = 0;
  if ($x > 0 && $in->{m}->[$y]->[$x - 1] & EAST) {
    $t |= WEST;
  }
  if ($x < $in->{w} && $in->{m}->[$y]->[$x + 1] & WEST) {
    $t |= EAST;
  }
  if ($y > 0 && $in->{m}->[$y - 1]->[$x] & SOUTH) {
    $t |= NORTH;
  }
  if ($y < $in->{h} && $in->{m}->[$y + 1]->[$x] & NORTH) {
    $t |= SOUTH;
  }
  $in->{m}->[$y]->[$x] = $t;
  my %v;
  my @s = [$x, $y, 0];
  my $mx = 0;
  while (my $cur = shift @s) {
    my ($x, $y, $c) = @$cur;
    next if (exists $v{$x, $y});
    $v{$x, $y} = 1;
    if ($mx < $c) {
      $mx = $c;
    }
    $c++;
    if ($in->{m}->[$y]->[$x] & WEST) {
      push @s, [$x - 1, $y, $c];
    }
    if ($in->{m}->[$y]->[$x] & EAST) {
      push @s, [$x + 1, $y, $c];
    }
    if ($in->{m}->[$y]->[$x] & NORTH) {
      push @s, [$x, $y - 1, $c];
    }
    if ($in->{m}->[$y]->[$x] & SOUTH) {
      push @s, [$x, $y + 1, $c];
    }
  }

  my $p2 = 0;
  for my $y (0 .. $in->{h} - 1) {
    my $c = 0;
    my $x = 0;
    my $turn = 0;
    while ($x < $in->{w}) {
      my $v = $in->{m}->[$y]->[$x];
      if (exists $v{$x, $y}) {
        $turn ^= $v;
        if (($turn & (NORTH | SOUTH)) == (NORTH | SOUTH)) {
          $c++;
          $x++;
          $turn = 0;
          next;
        }
        $x++;
        next;
      }
      $turn = 0;
      if ($c % 2) {
        $p2++;
      } else {
      }
      $x++;
    }
  }
  return [$mx, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
