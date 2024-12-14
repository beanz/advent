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

use constant {
  PX => 1,
  PY => 2,
  VX => 4,
  VY => 5,
};

sub calc {
  my ($in) = @_;
  my ($w, $h) = (101, 103);
  if (@$in <= 12) {
    ($w, $h) = (11, 7);
  }
  my ($qw, $qh) = (int($w / 2), int($h / 2));
  print STDERR scalar @$in, " $w x $h $qw x $qh\n" if DEBUG;
  my $p1 = 0;
  my @p = @$in;
  my $p2 = 0;
  for my $d (1 .. 10000) {
    my %s;
    for my $i (0 .. $#p) {
      $p[$i]->[PX] += $p[$i]->[VX];
      $p[$i]->[PY] += $p[$i]->[VY];
      $p[$i]->[PX] %= $w;
      $p[$i]->[PY] %= $h;
      $s{$p[$i]->[PX], $p[$i]->[PY]}++;
    }
    if ($d == 100) {
      $p1 = score(\@p, $qw, $qh);
      if ($p2 > 0) {
        last;
      }
    }
    if (keys %s == @p && $p2 == 0) {
      $p2 = $d;
      if ($p1 > 0) {
        last;
      }
    }
    next unless DEBUG;
    pp(\@p, $w, $h, $d);
  }
  return [$p1, $p2];
}

sub pp {
  my ($pp, $w, $h, $d) = @_;

  print "D: $d\n";
  for my $y (0 .. $h - 1) {
    for my $x (0 .. $w - 1) {
      my $c = grep {$_->[PX] == $x && $_->[PY] == $y} @$pp;
      $c ||= '.';
      print "$c";
    }
    print "\n";
  }
}

sub score {
  my ($pp, $qw, $qh) = @_;
  my @q = (0, 0, 0, 0);
  for my $p (@$pp) {
    if ($p->[PX] < $qw && $p->[PY] < $qh) {
      $q[0]++;
    } elsif ($p->[PX] > $qw && $p->[PY] < $qh) {
      $q[1]++;
    } elsif ($p->[PX] < $qw && $p->[PY] > $qh) {
      $q[2]++;
    } elsif ($p->[PX] > $qw && $p->[PY] > $qh) {
      $q[3]++;
    }
  }
  print STDERR "@q\n" if DEBUG;
  return product @q;
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
