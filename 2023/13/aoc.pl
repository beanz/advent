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
  my $in = read_chunks($file);
  my @c;
  for my $i (0 .. (@$in - 1)) {
    my $ch = $in->[$i];
    push @c, [map {[split //]} split /\n/, $ch];
  }
  return \@c;
}

sub reflect {
  my ($p, $wrong) = @_;
  $wrong //= 0;
  my $w = @{$p->[0]};
  my $h = @$p;
COL:
  for my $r (0 .. $w - 2) {
    my $cw = 0;
    for my $o (0 .. $w - 1) {
      my $xl = $r - $o;
      my $xr = $r + $o + 1;
      next unless (0 <= $xl && $xr < $w);
      for my $y (0 .. $h - 1) {
        if ($p->[$y]->[$xl] ne $p->[$y]->[$xr]) {
          $cw++;
        }
      }
    }
    if ($cw == $wrong) {
      return $r + 1;
    }
  }
ROW:
  for my $r (0 .. $h - 2) {
    my $cw = 0;
    for my $o (0 .. $h - 1) {
      my $yu = $r - $o;
      my $yd = $r + $o + 1;
      next unless (0 <= $yu && $yd < $h);
      for my $x (0 .. $w - 1) {
        if ($p->[$yu]->[$x] ne $p->[$yd]->[$x]) {
          $cw++;
        }
      }
    }
    if ($cw == $wrong) {
      return 100 * ($r + 1);
    }
  }
  return 1;
}

sub calc {
  my ($in) = @_;
  my ($p1, $p2) = (0,0);
  for my $l (@$in) {
    $p1 += reflect($l);
    $p2 += reflect($l, 1);
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
