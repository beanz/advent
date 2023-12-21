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
  my %m = (m => [map {[split //, $_]} @$in]);
  my $w = length $in->[0];
  my $h = scalar @$in;
  $m{W} = $w;
  $m{H} = $h;
  for my $y (0 .. $h - 1) {
    for my $x (0 .. $w - 1) {
      if ($m{m}->[$y]->[$x] eq 'S') {
        $m{m}->[$y]->[$x] = '.';
        $m{sx} = $x;
        $m{sy} = $y;
      }
    }
  }
  return \%m;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my %pos = ($in->{sx} . ',' . $in->{sy} => 1);
  for my $step (1 .. 64) {
    my %np;
    for my $p (keys %pos) {
      my ($x, $y) = split /,/, $p;
      for my $o ([0, 1], [0, -1], [1, 0], [-1, 0]) {
        my $nx = $x + $o->[X];
        my $ny = $y + $o->[Y];
        unless (0 <= $nx && $nx < $in->{W} && 0 <= $ny && $ny < $in->{H}) {
          next;
        }
        unless ($in->{m}->[$ny]->[$nx] eq '.') {
          next;
        }
        $np{$nx, $ny}++;
      }
    }
    $p1 = keys %np;
    %pos = %np;
  }
  my $p2 = 0;
  my $target = 26501365;
  my $mod = $target % $in->{W};
  %pos = ($in->{sx} . ',' . $in->{sy} => 1);
  my @seen;
  for my $step (1 .. 1000) {
    my %np;
    for my $p (keys %pos) {
      my ($x, $y) = split /,/, $p;
      for my $o ([0, 1], [0, -1], [1, 0], [-1, 0]) {
        my $nx = $x + $o->[X];
        my $ny = $y + $o->[Y];
        unless ($in->{m}->[($ny % $in->{H})]->[($nx % $in->{W})] eq '.') {
          next;
        }
        $np{$nx, $ny}++;
      }
    }
    $p2 = keys %np;
    if (($step % $in->{W}) == $mod) {
      #print "$step: $p2\n";
      push @seen, $p2;
      if (@seen == 3) {
        last;
      }
    }
    %pos = %np;
  }

  #print "@seen\n";
  my $x = ceil($target / $in->{W});
  my $a = int((($seen[2] - $seen[1]) - ($seen[1] - $seen[0])) / 2);
  my $b = ($seen[1] - $seen[0]) - 3 * $a;
  my $c = $seen[0] - $b - $a;
  $p2 = $a * $x * $x + $b * $x + $c;

  return [$p1, $p2];
}

sub pp {
  my ($in, $r) = @_;
  for my $y (0 .. $in->{H} - 1) {
    for my $x (0 .. $in->{W} - 1) {
      if (exists $r->{$x, $y}) {
        print "O";
      } else {
        print $in->{m}->[$y]->[$x];
      }
    }
    print "\n";
  }
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
