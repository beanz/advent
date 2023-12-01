#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);
$i = [sort { $a <=> $b } @$i];

sub calc {
  my ($in, $pre) = @_;
  my $max = 3 + $in->[-1];
  push @$in, $max;
  my $cj = 0;
  my %d;
  for my $j (@$in) {
    my $d = $j-$cj;
    $d{$d}++;
    $cj = $j;
  }
  return $d{1} * $d{3};
}

sub calc2 {
  my ($in) = @_;
  my @present = (0) x $in->[-1];
  for my $e (@$in) {
    $present[$e-1] = 1;
  }
  my @trib = (0, 0, 1);
  for my $e (@present) {
    my $s = sum @trib;
    shift @trib;
    push @trib, $s * $e;
  }
  return $trib[2];
}

testPart1() if (TEST);

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 7*5 ],
     [ "test2.txt", 220 ],
    );
  for my $tc (@test_cases) {
    my $in = read_lines($tc->[0]);
    $in = [sort { $a <=> $b } @$in];
    my $res = calc($in);
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 8 ],
     [ "test2.txt", 19208 ],
    );
  for my $tc (@test_cases) {
    my $in = read_lines($tc->[0]);
    $in = [sort { $a <=> $b } @$in];
    my $res = calc2($in);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
