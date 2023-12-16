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
  my $in = read_lines($file);
  my @m = map {[split //, $_]} @$in;
  return \@m;
}

sub cw {
  my ($dir) = @_;
  return [$dir->[1] * -1, $dir->[0]];
}

sub ccw {
  my ($dir) = @_;
  return [$dir->[1], $dir->[0] * -1];
}

sub pp {
  my ($in, $seen) = @_;
  for my $y (0 .. @$in - 1) {
    for my $x (0 .. @{$in->[0]} - 1) {
      if ($seen->{"$x,$y"}) {
        print bold($in->[$y]->[$x]);
      } else {
        print $in->[$y]->[$x];
      }
    }
    print "\n";
  }
}

sub solve {
  my ($in, $pos, $dir) = @_;
  my %seen;
  my @todo = [$pos, $dir];
  while (@todo) {
    my $cur = shift @todo;
    my ($pos, $dir) = @$cur;
    my ($x, $y) = @$pos;
    if ($x < 0 || $x>= @{$in->[0]} || $y < 0 || $y >= @{$in}) {
      next;
    }
    next if ($seen{"@$pos"}->{"@$dir"});
    $seen{"@$pos"}->{"@$dir"}++;
    my $ch = $in->[$y]->[$x];
    if ($dir->[Y] == 0 && $ch eq '|') {
      push @todo, [[$x, $y-1], [0,-1]], [[$x, $y+1], [0,1]];
      next;
    }
    if ($dir->[X] == 0 && $ch eq '-') {
      push @todo, [[$x-1, $y], [-1,0]], [[$x, $y], [1,0]];
      next;
    }
    if ($dir->[X] == 0 && $ch eq '\\') {
      my $nd = ccw($dir);
      push @todo, [[$x+$nd->[X], $y+$nd->[Y]], $nd];
      next;
    }
    if ($dir->[X] == 0 && $ch eq '/') {
      my $nd = cw($dir);
      push @todo, [[$x+$nd->[X], $y+$nd->[Y]], $nd];
      next;
    }
    if ($dir->[Y] == 0 && $ch eq '\\') {
      my $nd = cw($dir);
      push @todo, [[$x+$nd->[X], $y+$nd->[Y]], $nd];
      next;
    }
    if ($dir->[Y] == 0 && $ch eq '/') {
      my $nd = ccw($dir);
      push @todo, [[$x+$nd->[X], $y+$nd->[Y]], $nd];
      next;
    }
    push @todo, [[$x+$dir->[X], $y+$dir->[Y]], $dir];
  }
  #pp($in, \%seen);
  return scalar keys %seen;
}

sub calc {
  my ($in) = @_;
  my $dir = [1, 0];
  my $pos = [0, 0];
  my $p1 = solve($in, $pos, $dir);
  my $p2 = 0;
  for my $x (0 .. @$in) {
    my $down = solve($in, [$x, 0], [0, 1]);
    $p2 = $down if ($down > $p2);
    my $up = solve($in, [$x, @$in - 1], [0, -1]);
    $p2 = $up if ($up > $p2);
  }
  for my $y (0 .. @{$in->[0]}) {
    my $right = solve($in, [0, $y], [1, 0]);
    $p2 = $right if ($right > $p2);
    my $left = solve($in, [@{$in->[0]} - 1, $y], [-1,0]);
    $p2 = $left if ($left > $p2);
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
