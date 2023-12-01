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

sub visible {
  my ($in, $x, $y, $ch) = @_;
  return 1 if ($x == 0 || $y == 0 || $x==$in->width()-1 || $y == $in->height()-1);
  for my $o ([-1,0], [0,-1], [1,0], [0,1]) {
    my $nx = $x+$o->[0];
    my $ny = $y+$o->[1];
    my $v = 1;
    while($nx >= 0 && $nx < $in->width() && $ny >= 0 && $ny < $in->height()) {
      if ($in->get($nx, $ny) >=$ch) {
        $v = 0;
        last;
      }
    $nx = $nx+$o->[0];
    $ny = $ny+$o->[1];
    }
    return 1 if ($v);
  }
  return 0;
}

sub calc {
  my ($in) = @_;
  my $c = 0;
  unless (visible($in, 1,2, $in->get(1,2))) {
    return -1;
  }
  for my $y (0..$in->height()-1) {
  for my $x (0..$in->width()-1) {
    my $v = $in->get($x,$y);
    my $visible = visible($in, $x, $y, $v);
    $c++ if ($visible);
  }
  }
  return $c;
}

sub score {
  my ($in, $x, $y, $ch) = @_;
  my $s = 1;
  for my $o ([-1,0], [0,-1], [1,0], [0,1]) {
    my $nx = $x+$o->[0];
    my $ny = $y+$o->[1];
    my $c = 0;
    while($nx >= 0 && $nx < $in->width() && $ny >= 0 && $ny < $in->height()) {
      $c++;
      if ($in->get($nx, $ny) >=$ch) {
        last;
      }
      $nx = $nx+$o->[0];
      $ny = $ny+$o->[1];
    }
    $s*=$c;
    if ($s == 0) {
      last;
    }
  }
  return $s;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  for my $y (0..$in->height()-1) {
    for my $x (0..$in->width()-1) {
      my $v = $in->get($x,$y);
      my $score = score($in, $x, $y, $v);
      $c=$score if ($score > $c);
    }
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 21 ],
     [ "input.txt", 1681 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 8 ],
     [ "input.txt", 201684 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
