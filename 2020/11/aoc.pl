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

sub readfn {
  $_[0] eq '.' ? NONE : ($_[0] eq 'L' ? EMPTY : OCCUPIED);
}

sub strfn {
  $_[0] == NONE ? '.' : ($_[0] == EMPTY ? 'L' : '#');
}

sub neighbours {
  my ($m, $x, $y, $sight, $width, $height) = @_;
  my @n;
  for my $o (@EIGHT_NEIGHBOUR_OFFSETS) {
    my $ox = $x+$o->[X];
    my $oy = $y+$o->[Y];
    my $s = NONE;
    while ($ox >= 0 && $ox < $width && $oy >= 0 && $oy < $height) {
      $s = $m->get_idx($ox + $oy*$width);
      if ($s != NONE or !$sight) {
        last;
      }
      $ox += $o->[X];
      $oy += $o->[Y];
    }
    if ($s != NONE) {
      push @n, $ox + $width*$oy;
    }
  }
  return \@n;
}

sub read_map {
  my ($file) = @_;
  my $m = read_dense_map($file, \&readfn, \&strfn);
  my $n = $m->clone();
  my $width = $m->width;
  my $height = $m->height;
  my %cache;
  for my $i (0..$m->last_index) {
    my $xy = $m->xy($i);
    next if ($m->get(@$xy) == NONE);
    my $n1 = neighbours($m, @$xy, 0, $width, $height);
    my $n2 = neighbours($m, @$xy, 1, $width, $height);
    $cache{$i} = [$n1, $n2];
  }
  return [$m, $n, \%cache];
}

sub occupiedCount {
  my ($m, $cache, $sight) = @_;
  my $c = 0;
  for my $i (@{$cache->[$sight ? 1 : 0]}) {
    $c++ if ($m->get_idx($i) == OCCUPIED);
  }
  return $c;
}

sub run {
  my ($cur, $new, $idx, $group, $sight) = @_;
  print $cur->pretty(),"\n" if (DEBUG > 1);
  my @i = keys %{$idx};
  while (1) {
    my %n;
    my $c = 0;
    my $ch = 0;
    for my $i (@i) {
      my $s = $cur->get_idx($i);
      my $n = $s;
      my $oc = occupiedCount($cur, $idx->{$i}, $sight);
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
