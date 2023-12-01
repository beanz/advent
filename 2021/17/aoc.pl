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
#my $reader = \&read_lines;
my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

use constant
  {
   XMIN => 0,
   XMAX => 1,
   YMIN => 2,
   YMAX => 3,
  };

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my $m = [ $in->[0] =~ m/(-?\d+)/mg ];
  return $m;
}

sub calc {
  my ($in) = @_;
  return int($in->[YMIN]*($in->[YMIN]+1)/2)
}

sub try {
  my ($in, $v) = @_;
  my $p = [0,0];
  my $my = 0;
  for my $n (0..1000) {
    $p->[X] += $v->[X];
    $p->[Y] += $v->[Y];
    #print "$p->[X], $p->[Y]\n" if DEBUG;
    if (!defined $my || $my < $p->[Y]) {
      $my = $p->[Y];
    }
    if ($v->[X] > 0) {
      $v->[X]--;
    } elsif ($v->[X] < 0) {
      $v->[X]++;
    }
    $v->[Y]--;
    if ($in->[XMIN] <= $p->[X] && $p->[X] <= $in->[XMAX] &&
        $in->[YMIN] <= $p->[Y] && $p->[Y] <= $in->[YMAX]) {
      return $my;
    }
    if ($p->[Y] < $in->[YMIN]) {
      last;
    }
    if ($v->[X] == 0 && !($in->[XMIN] <= $p->[X] && $p->[X] <= $in->[XMAX])) {
      last;
    }
  }
  return
}

sub calc2 {
  my ($in) = @_;
  my $my = 0;
  my $p2 = 0;
  my $bb = [];
  for my $vx (0..$in->[XMAX]) {
    for my $vy (-abs($in->[YMIN])..abs($in->[YMIN])) {
      printf "%6d,%6d %d %d\r", $vx, $vy, $my, $p2 if DEBUG;
      my $t = try($in, [$vx,$vy]);
      if (defined $t && (!defined $my || $my < $t)) {
        $my = $t;
      }
      if (defined $t) {
        minmax_xy($bb, $vx,$vy);
        $p2++;
      }
    }
  }
  print "\n" if DEBUG;
  print "@$bb\n" if DEBUG;
  return [$my, $p2];
}

testParts() if (TEST);

print "Part 1: ", calc($i), "\n";
my $p2 = calc2($i);
print "Part 2: ", $p2->[1], "\n";

sub testParts {
  my @test_cases =
    (
     [ "test1.txt", 45, 112 ],
     [ "input.txt", 2850, 1117 ],
    );
  for my $tc (@test_cases) {
    assertEq("Test 1 [$tc->[0]]", calc($reader->($tc->[0])), $tc->[1]);
    my $p2 = calc2($reader->($tc->[0]));
    print "@$p2\n";
    assertEq("Test 2 [$tc->[0]]", $p2->[1], $tc->[2]);
  }
}
