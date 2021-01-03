#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);

sub sq {
  my ($l, $p) = @_;
  my $n = @$i;
  my $m = length $l->[0];
  return substr $l->[$p->[1]%$n], $p->[0]%$m, 1;
}

sub calc {
  my ($i, $s) = @_;
  $s //= [3, 1];
  my $c = 0;
  my $p = [0,0];
  my $n = @$i - 1;
  while ($p->[1] <= $n) {
    my $sq = sq($i, $p);
    $c++ if (sq($i, $p) eq '#');
    print STDERR "$p->[0],$p->[1] $c\n" if DEBUG;
    $p->[0] += $s->[0];
    $p->[1] += $s->[1];
  }
  return $c;
}

if (TEST) {
  my @test_cases =
    (
     [ 'test1.txt', 7 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i) = @_;
  my $p = 1;
  for my $slope ([1,1],[3,1],[5,1],[7,1],[1,2]) {
    my $r = calc($i, $slope);
    print STDERR $r, "\n" if DEBUG;
    $p *= $r;
  }
  return $p;
}

if (TEST) {
  my @test_cases =
    (
     [ 'test1.txt', 336 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}

$i = read_lines($file); # reset input
print "Part 2: ", calc2($i), "\n";
