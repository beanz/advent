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

my $reader = \&read_dense_map;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub cw {
  my ($d) = @_;
  return [$d->[Y] * -1, $d->[X]];
}

sub calc {
  my ($in) = @_;
  my $opos;
LOOP:
  for my $y (0 .. $in->width - 1) {
    for my $x (0 .. $in->height - 1) {
      if ($in->get($x, $y) eq '^') {
        $opos = [$x, $y];
        last LOOP;
      }
    }
  }

  my $p1;
  my $p2;
  for my $oy (0 .. $in->width - 1) {
    for my $ox (0 .. $in->height - 1) {
      print STDERR "$ox, $oy ", $in->get($ox, $oy), "\n" if DEBUG;
      if ($in->get($ox, $oy) eq '#' && $p1) {
        next;
      }
      my $pos = $opos;
      my $dir = [0, -1];
      my %seen;
      my %seen2;
      while (defined $in->index(@$pos)) {
        if ($seen2{"@$pos@$dir"}) {
          $p2 += 1;
          last;
        }
        $seen2{"@$pos@$dir"}++;
        $seen{"@$pos"}++;
        my $npos = [$pos->[X] + $dir->[X], $pos->[Y] + $dir->[Y]];
        my $ch = $in->get(@$npos);
        if ($ch eq '#' || ($npos->[X] == $ox && $npos->[Y] == $oy)) {
          $dir = cw($dir);
          next;
        }
        $pos = $npos;
      }
      if ($in->get($ox, $oy) eq '#') {
        $p1 = keys %seen;
      }
    }
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
