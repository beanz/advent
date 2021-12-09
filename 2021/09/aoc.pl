#!/usr/bin/perl
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

use constant
  {
   RISK => 4,
   LOWS => 5,
  };

sub find_risk {
  my ($in) = @_;
  $in->[RISK] = 0;
  $in->[LOWS] = [];
  for my $y (0..$in->height-1) {
    for my $x (0..$in->width-1) {
      my $p = $in->get($x, $y);
      if ($y > 0) {
        next unless ($p < $in->get($x, $y-1));
      }
      if ($y < ($in->height-1)) {
        next unless ($p < $in->get($x, $y+1));
      }
      if ($x > 0) {
        next unless ($p < $in->get($x-1, $y));
      }
      if ($x < ($in->width-1)) {
        next unless ($p < $in->get($x+1, $y));
      }
      print STDERR "$x,$y r=",($p+1),"\n" if DEBUG;
      push @{$in->[LOWS]}, [$x, $y, $p];
      $in->[RISK] += $p+1;
    }
  }
}

sub calc {
  my ($in) = @_;
  find_risk($in);
  return $in->[RISK];
}

sub calc2 {
  my ($in) = @_;
  my @s;
  for my $r (@{$in->[LOWS]}) {
    my $vc = visit_checker();
    my $c = 0;
    my $todo = [$r];
    while (@$todo) {
      my ($x, $y, $p) = @{shift @$todo};
      next if ($vc->($x,$y));
      $c += 1;
      if ($y > 0) {
        my $v = $in->get($x, $y-1);
        push @$todo, [$x, $y-1, $v] if ($v < 9);
      }
      if ($y < ($in->height-1)) {
        my $v = $in->get($x, $y+1);
        push @$todo, [$x, $y+1, $v] if ($v < 9);
      }
      if ($x > 0) {
        my $v = $in->get($x-1, $y);
        push @$todo, [$x-1, $y, $v] if ($v < 9);
      }
      if ($x < ($in->width-1)) {
        my $v = $in->get($x+1, $y);
        push @$todo, [$x+1, $y, $v] if ($v < 9);
      }
    }
    print STDERR "$r->[0],$r->[1] s=$c\n" if DEBUG;
    push @s, $c;
  }
  @s = sort {$a <=> $b} @s;
  return $s[-1] * $s[-2] * $s[-3];
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 15 ],
     [ "input.txt", 456 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 1134 ],
     [ "input.txt", 1047744 ],
    );
  for my $tc (@test_cases) {
    my $i = $reader->($tc->[0]);
    calc($i);
    my $res = calc2($i);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
