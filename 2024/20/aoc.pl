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
  my $in = read_2024($file);
  my %m = (m => $in);
  for my $y (0 .. $in->height - 1) {
    for my $x (0 .. $in->width - 1) {
      my $ch = $in->get($x, $y);
      if ($ch eq 'S') {
        $m{sx} = $x;
        $m{sy} = $y;
      } elsif ($ch eq 'E') {
        $m{ex} = $x;
        $m{ey} = $y;
      }
    }
  }
  return \%m;
}

use constant {
  DX => [0, 1, 0, -1],
  DY => [-1, 0, 1, 0],
};

sub calc {
  my ($in) = @_;
  my ($m, $sx, $sy, $ex, $ey) =
    ($in->{m}, $in->{sx}, $in->{sy}, $in->{ex}, $in->{ey});
  my $limit = 100;
  $limit = 20 if ($m->width < 20);
  my $best = 0;
  my @todo = [$sx, $sy, 0];
  my %seen;
  while (@todo) {
    my $cur = shift @todo;
    my ($cx, $cy, $st) = @$cur;
    if (exists $seen{$cx, $cy}) {
      next;
    }
    $seen{$cx, $cy} = $st;
    if ($cx == $ex && $cy == $ey) {
      $best = $st;
    }
    for my $dir (0 .. 3) {
      my ($nx, $ny) = ($cx + DX->[$dir], $cy + DY->[$dir]);
      if ($in->{m}->get($nx, $ny) ne '#') {
        push @todo, [$nx, $ny, $st + 1];
      }
    }
  }
  return [solve($m, \%seen, 2, $limit), solve($m, \%seen, 20, $limit)];
}

sub solve {
  my ($m, $seen, $dist, $limit) = @_;
  my @cheats;
  my @cheat_offset = @{cheat_neighbours($m, $dist)};
  my $res = 0;
  for my $y (0 .. $m->height) {
    for my $x (0 .. $m->width) {
      my $st = $seen->{$x, $y} // next;
      for my $o (@cheat_offset) {
        my ($ox, $oy, $md) = @$o;
        my ($nx, $ny) = ($x + $ox, $y + $oy);
        if (exists $seen->{$nx, $ny} && $m->get($nx, $ny) ne '#') {
          my $cheat = $seen->{$nx, $ny} - $st - $md;

          #print STDERR "CHEAT: $x,$y $st: $cheat >= $limit\n" if DEBUG;
          $res++ if ($cheat >= $limit);
        }
      }
    }
  }
  return $res;
}

sub cheat_neighbours {
  my ($m, $dist) = @_;
  my @res;
  for my $dy (-$dist .. $dist) {
    my $rem = $dist - abs($dy);
    for my $dx (-$rem .. $rem) {
      my $md = abs($dx) + abs($dy);
      if ($md > 1) {
        push @res, [$dx, $dy, $md];
      }
    }
  }
  return \@res;
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
