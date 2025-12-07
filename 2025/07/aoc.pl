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

no warnings 'recursion';
sub search {
  my ($m, $x, $y) = @_;
  return 0 if ($y >= $m->height);
  return 0 if ($m->get($x, $y) eq '@');
  if ($m->get($x, $y) eq '^') {
    $m->set($x, $y, '@');
    return 1 + search($m, $x - 1, $y) + search($m, $x + 1, $y);
  }
  return search($m, $x, $y + 1);
}

sub search2 {
  my ($m, $x, $y) = @_;
  state %s;
  return $s{"$x,$y"} if (defined $s{"$x,$y"});
  return 1 if ($y >= $m->height);
  my $ch = $m->get($x, $y);
  my $r;
  if ($ch eq '^' || $ch eq '@') {
    $r = search2($m, $x - 1, $y) + search2($m, $x + 1, $y);
  } else {
    $r = search2($m, $x, $y + 1);
  }
  $s{"$x,$y"} = $r;
  return $r;
}

sub calc {
  my ($in) = @_;
  my ($sx, $sy);
LOOP: for my $y (0 .. $in->width - 1) {
    for my $x (0 .. $in->height - 1) {
      if ($in->get($x, $y) eq 'S') {
        $sx = $x;
        $sy = $y;
        last LOOP;
      }
    }
  }
  my $p1 = search($in, $sx, $sy + 1);
  my $p2 = search2($in, $sx, $sy + 1);
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
