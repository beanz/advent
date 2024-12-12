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

sub area_per {
  my ($m, $s, $x, $y, $ch) = @_;
  my @todo = [$x, $y];
  my $w = $m->width;
  my $h = $m->height;
  my $a;
  my $p;
  my %p;
  while (@todo) {
    my $cur = pop @todo;
    my ($x, $y) = @$cur;
    next if ($s->{$x, $y});
    $s->{$x, $y}++;
    $a++;
    for my $o ([0, -1], [1, 0], [0, 1], [-1, 0]) {
      my ($nx, $ny) = ($x + $o->[X], $y + $o->[Y]);
      if ( 0 <= $nx
        && $nx < $w
        && 0 <= $ny
        && $ny < $h
        && $ch eq $m->get($nx, $ny))
      {
        push @todo, [$nx, $ny];
      } else {
        $p++;
        $p{$o->[X], $o->[Y]}->{$x, $y}++;
      }
    }
  }
  my $sides;
  for my $r (keys %p) {
    my ($ox, $oy) = split /,/, $r;
    my %s;
    for my $r2 (keys %{$p{$r}}) {
      my ($x, $y) = split /,/, $r2;
      next if ($s{$x, $y});
      $sides++;
      my @todo = [$x, $y];
      while (@todo) {
        my $cur = pop @todo;
        my ($x, $y) = @$cur;
        next if ($s{$x, $y});
        $s{$x, $y}++;
        for my $o ([0, -1], [1, 0], [0, 1], [-1, 0]) {    # check two
          my ($nx, $ny) = ($x + $o->[X], $y + $o->[Y]);
          push @todo, [$nx, $ny] if (exists $p{$r}->{$nx, $ny});
        }
      }

    }
  }
  return [$a, $p, $sides];
}

sub calc {
  my ($m) = @_;
  my $p1 = 0;
  my $p2 = 0;
  my %s;
  for my $y (0 .. $m->width - 1) {
    for my $x (0 .. $m->height - 1) {
      next if ($s{$x, $y});
      #print STDERR "$x,$y: ", $m->get($x, $y), "\n";
      my $ch = $m->get($x, $y);
      my $r = area_per($m, \%s, $x, $y, $ch);
      my ($a, $p, $s) = @$r;
      print STDERR "$ch $a $p ", ($a * $p), " $s ", ($a * $s), "\n" if DEBUG;
      $p1 += $a * $p;
      $p2 += $a * $s;
    }
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
