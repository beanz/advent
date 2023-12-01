#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);

sub seat_id {
  my ($p) = @_;
  my $sm = 1024;
  my $s = 0;
  for my $c (split//,$p) {
    #print "B: @r : @c\n";
    if ($c eq "F" || $c eq 'L') {
      $sm /= 2;
    } elsif ($c eq "B" || $c eq 'R') {
      $sm /= 2;
      $s += $sm;
    }
    #print "A: @r : @c\n";
  }
  return $s
}

sub calc {
  my ($i, $part) = @_;
  $part //= 1;
  my @id;
  for my $l (@$i) {
    push @id, seat_id($l);
  }
  return max @id;
}

if (TEST) {
  my @test_cases =
    (
     [ "FBFBBFFRLR", 357 ],
     [ "BFFFBBFRRR", 567 ],
     [ "FFFBBBFRRR", 119 ],
     [ "BBFFBBFRLL", 820 ],
    );
  for my $tc (@test_cases) {
    my $res = seat_id($tc->[0]);
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
  assertEq("Test 1 test1.txt", calc(read_lines("test1.txt")), 820);
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i, $part) = @_;
  $part //= 1;
  my @id;
  for my $l (@$i) {
    push @id, seat_id($l);
  }
  my $p = -3;
  for my $s (sort { $a <=> $b } @id) {
    return $s-1 if ($p == $s-2);
    $p = $s;
  }
  return 0;
}

if (TEST) {
  my @test_cases =
    (
     [ "test1.txt", 0 ],
     [ "input.txt", 636 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}

$i = read_lines($file);
print "Part 2: ", calc2($i), "\n";
