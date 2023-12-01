#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_guess;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my $c = 0;
  for (@$in) {
    $c += 10 * $1 if (/^.*?(\d)/);
    $c += $1 if (/^.*(\d)/);
  }
  return $c;
}

my %n = (
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
);
for (1 .. 9) {
  $n{$_} = $_;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  my $p = '(' . (join '|', keys %n) . ')';
  for (@$in) {
    $c += 10 * $n{$1} if (/^.*?$p/o);
    $c += $n{$+} if (/^.*$p/o);
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 142], ["input.txt", 54390],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test2.txt", 281], ["input.txt", 54277],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
