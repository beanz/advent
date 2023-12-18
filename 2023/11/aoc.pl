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

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @m = map {[split //]} @$in;
  return \@m;
}

sub calc {
  my ($in, $ex) = @_;
  $ex //= 1000000;
  my $h = @$in;
  my $w = @{$in->[0]};
  my @x = (0) x $w;
  my @y = (0) x $h;
  my @bb;
  my $gc = 0;

  for my $y (0 .. $h - 1) {
    for my $x (0 .. $w - 1) {
      if ($in->[$y]->[$x] ne '.') {
        $gc++;
        minmax_xy(\@bb, $x, $y);
        $x[$x]++;
        $y[$y]++;
      }
    }
  }

  #print "X: @x\n";
  #print "Y: @y\n";
  #print "GC: $gc\n";

  my $dx = dist($gc, $bb[MINX], $bb[MAXX], \@x, 2);
  my $dy = dist($gc, $bb[MINY], $bb[MAXY], \@y, 2);
  my $dx2 = dist($gc, $bb[MINX], $bb[MAXX], \@x, $ex);
  my $dy2 = dist($gc, $bb[MINY], $bb[MAXY], \@y, $ex);
  return [$dx + $dy, $dx2 + $dy2];
}

sub dist {
  my ($gc, $min, $max, $v, $mul) = @_;
  my $exp = 0;
  my $d = 0;
  my ($px, $nx) = ($min, $v->[$min]);
  for my $x ($min + 1 .. $max) {
    if ($v->[$x]) {
      $d += ($x - $px + $exp) * $nx * ($gc - $nx);
      $nx += $v->[$x];
      $px = $x;
      $exp = 0;
    } else {
      $exp += ($mul - 1);
    }
  }
  return $d;
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
