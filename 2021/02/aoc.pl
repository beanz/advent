#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my $p = [0,0];
  for my $l (@$in) {
    my ($inst, $n) = split / /, $l;
    if ($inst eq "forward") {
      $p->[X] += $n;
    }  elsif ($inst eq "down") {
      $p->[Y] += $n;
    }  elsif ($inst eq "up") {
      $p->[Y] -= $n;
    }
  }
  return $p->[X] * $p->[Y];
}

sub calc2 {
  my ($in) = @_;
  my $p = [0,0,0];
  for my $l (@$in) {
    my ($inst, $n) = split / /, $l;
    if ($inst eq "forward") {
      $p->[X] += $n;
      $p->[Y] += $p->[Z] * $n;
    }  elsif ($inst eq "down") {
      $p->[Z] += $n;
    }  elsif ($inst eq "up") {
      $p->[Z] -= $n;
    }
  }
  return $p->[X] * $p->[Y];
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 150 ],
     [ "input.txt", 1714950 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 900, ],
     [ "input.txt", 1281977850 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
