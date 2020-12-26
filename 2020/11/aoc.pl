#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;

my @EIGHT_NEIGHBOUR_OFFSETS = @{eightNeighbourOffsets()};

my $file = shift // "input.txt";
my $i = read_map($file);

use constant
  {
   NONE => 0,
   EMPTY => 1,
   OCCUPIED => 2,
  };

sub readfn {
  $_[0] eq '.' ? NONE : ($_[0] eq 'L' ? EMPTY : OCCUPIED);
}

sub strfn {
  $_[0] == NONE ? '.' : ($_[0] == EMPTY ? 'L' : '#');
}

sub read_map {
  my ($file) = @_;
  my $m = read_dense_map($file, \&readfn, \&strfn);
  my %idx;
  my $maxx = $m->width-1;
  my $maxy = $m->height-1;
  for my $i (0..$m->last_index) {
    my $xy = $m->xy($i);
    if ($m->get(@$xy) != NONE) {
      $idx{$i} =
        [@$xy,
         neighbourIndexes($m, $xy, 0, $maxx, $maxy),
         neighbourIndexes($m, $xy, 1, $maxx, $maxy)];
    }
  }
  return [$m, \%idx];
}

sub neighbourIndexes {
  my ($m, $xy, $sight, $maxx, $maxy) = @_;
  my ($x, $y) = @$xy;
  my $width = $maxx+1;
  my @n;
  for my $o (@EIGHT_NEIGHBOUR_OFFSETS) {
    my $ox = $x+$o->[X];
    my $oy = $y+$o->[Y];
    my $oi;
    my $s = NONE;
    while ($ox >= 0 && $ox <= $maxx && $oy >= 0 && $oy <= $maxy) {
      $oi = $ox + $oy*$width;
      $s = $m->get_idx($oi);
      if ($s != NONE or !$sight) {
        last;
      }
      $ox += $o->[X];
      $oy += $o->[Y];
    }
    push @n, $oi if ($s != NONE);
  }
  return \@n;
}

sub occupiedCount {
  my ($m, $ni) = @_;
  my $c = 0;
  for my $i (@$ni) {
    $c++ if ($m->get_idx($i) == OCCUPIED);
  }
  return $c;
}

sub run {
  my ($map, $idx, $group, $sight) = @_;
  my $cur = $map->clone();
  my $new = $map->clone();
  print $cur->pretty(),"\n" if (DEBUG > 1);
  my @i = keys %{$idx};
  my $maxx = $cur->width-1;
  my $maxy = $cur->height-1;
  while (1) {
    my %n;
    my $c = 0;
    my $ch = 0;
    for my $i (@i) {
      my ($x, $y, $ni, $niS) = @{$idx->{$i}};
      my $s = $cur->get_idx($i);
      my $n = $s;
      my $oc = occupiedCount($cur, $sight ? $niS : $ni);
      if ($s == EMPTY && $oc == 0) {
        $ch++;
        $n = OCCUPIED;
      } elsif ($s == OCCUPIED && $oc >= $group) {
        $ch++;
        $n = EMPTY;
      }
      $c++ if ($n == OCCUPIED);
      $new->set_idx($i, $n);
    }
    $cur->swap($new);
    if (DEBUG) {
      print $cur->pretty() if (DEBUG > 1);
      print "changes=$ch oc=$c\n";
    }
    if ($ch == 0) {
      return $c;
    }
  }
  return 1;
}

sub calc {
  my ($m) = @_;
  return run(@$m, 4, 0);
}

sub calc2 {
  my ($m) = @_;
  return run(@$m, 5, 1);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 37 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_map($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 26 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_map($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
