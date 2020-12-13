#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_map($file);
#dd([$i]); exit;
my $i2 = read_map($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

use constant
  {
   NONE => 0,
   EMPTY => 1,
   OCCUPIED => 2,
  };

my @EIGHT_NEIGHBOUR_OFFSETS = @{eightNeighbourOffsets()};

sub readfn {
  $_[0] eq '.' ? NONE : ($_[0] eq 'L' ? EMPTY : OCCUPIED);
}

sub strfn {
  $_[0] == NONE ? '.' : ($_[0] == EMPTY ? 'L' : '#');
}

sub read_map {
  my ($file) = @_;
  my $m = read_dense_map($file, \&readfn, \&strfn);
  my $n = $m->clone();
  my %idx;
  for my $i (0..$m->last_index) {
    my $xy = $m->xy($i);
    $idx{$i} = $xy if ($m->get(@$xy) != NONE);
  }
  return [$m, $n, \%idx];
}

sub occupiedCount {
  my ($m, $x, $y, $sight, $maxx, $maxy) = @_;
  my $width = $maxx+1;
  my $c = 0;
  for my $o (@EIGHT_NEIGHBOUR_OFFSETS) {
    my $ox = $x+$o->[X];
    my $oy = $y+$o->[Y];
    my $s = NONE;
    while ($ox >= 0 && $ox <= $maxx && $oy >= 0 && $oy <= $maxy) {
      $s = $m->get_idx($ox + $oy*$width);
      if ($s != NONE or !$sight) {
        last;
      }
      $ox += $o->[X];
      $oy += $o->[Y];
    }
    $c++ if ($s == OCCUPIED);
  }
  return $c;
}

sub run {
  my ($cur, $new, $idx, $group, $sight) = @_;
  print $cur->pretty(),"\n" if (DEBUG > 1);
  my @i = keys %{$idx};
  my $maxx = $cur->width-1;
  my $maxy = $cur->height-1;
  while (1) {
    my %n;
    my $c = 0;
    my $ch = 0;
    for my $i (@i) {
      my ($x, $y) = @{$idx->{$i}};
      my $s = $cur->get_idx($i);
      my $n = $s;
      my $oc = occupiedCount($cur, $x, $y, $sight, $maxx, $maxy);
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

print "Part 2: ", calc2($i2), "\n";

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
