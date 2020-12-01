#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);

sub calc {
  my ($i, $part) = @_;
  $part //= 1;
  for my $a (0..(scalar @$i-1)) {
    for my $b ($a+1 .. (scalar @$i-1)) {
#      print "$a $b $i->[$a] + $i->[$b] = ", $i->[$a] + $i->[$b], "\n"
#        if (DEBUG);
      if ($i->[$a] + $i->[$b] == 2020) {
        return $i->[$a] * $i->[$b];
      }
    }
  }
  return 0;
}

if (TEST) {
  my @test_cases =
    (
     [ 'test1.txt', 514579 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i, $part) = @_;
  $part //= 1;
  for my $a (0..(scalar @$i-1)) {
    for my $b ($a+1 .. (scalar @$i-1)) {
      for my $c ($b+1 .. (scalar @$i-1)) {
        if ($i->[$a] + $i->[$b] + $i->[$c] == 2020) {
          return $i->[$a] * $i->[$b] * $i->[$c];
        }
      }
    }
  }
  return 0;
}

if (TEST) {
  my @test_cases =
    (
     [ 'test1.txt', 241861950 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}

$i = read_lines($file); # reset input
print "Part 2: ", calc2($i), "\n";
