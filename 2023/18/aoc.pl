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

sub calc {
  my ($in) = @_;
  my ($x1, $y1) = (0,0);
  my ($x2, $y2) = (0,0);
  my ($p1a,$p1p) = (0,0);
  my ($p2a,$p2p) = (0,0);
  my $sn = 0;
  for my $l (@$in) {
    my ($d, $n, $col) = @$l;
    my ($ox, $oy) =@{ { R => [1,0], D => [0,1], L => [-1,0], U => [0,-1] }->{$d}};
    my ($nx, $ny) = ($x1 + $ox*$n, $y1 + $oy*$n);
    $p1a += ($x1-$nx) * ($y1+$ny);
    ($x1, $y1) = ($nx, $ny);
    $p1p += $n;
    my ($h, $hd) = ($col =~ /#(.....)(.)/);
    $n = hex($h);
    ($ox, $oy) =@{ [ [1,0], [0,1], [-1,0], [0,-1] ]->[$hd] };
    ($nx, $ny) = ($x2 + $ox*$n, $y2 + $oy*$n);
    $p2a += ($x2-$nx) * ($y2+$ny);
    ($x2, $y2) = ($nx, $ny);
    $p2p += $n;
  }
  return [(abs($p1a)+$p1p+2)/2, (abs($p2a)+$p2p+2)/2];
}

RunTests(sub { my $f = shift; calc($reader->($f), @_) }) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
