#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  return [split/,/, read_lines($file)->[0] ];
}

sub fuel {
  my ($a, $b) = @_;
  my $f = abs($a - $b);
  #  print "$a to $b: $f\n";
  return $f;
}

sub fuel2 {
  my ($a, $b) = @_;
  my $f = abs($a - $b);
  return $f*($f+1)/2;
}

sub min_fuel {
  my ($in, $fn) = @_;
  return min(map {
    my $v = $_; sum(map { $fn->($v, $_) } @$in)
  } min(@$in)..max(@$in));
}

sub calc {
  return min_fuel($_[0], \&fuel);
}

sub calc2 {
  return min_fuel($_[0], \&fuel2);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 37 ],
     [ "input.txt", 336701 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  assertEq("F2 16, 5", fuel2(16, 5), 66);
  assertEq("F2 1, 5", fuel2(1, 5), 10);
  assertEq("F2 2, 5", fuel2(2, 5), 6);
  assertEq("F2 0, 5", fuel2(0, 5), 15);
  assertEq("F2 4, 5", fuel2(4, 5), 1);
  assertEq("F2 2, 5", fuel2(2, 5), 6);
  assertEq("F2 7, 5", fuel2(7, 5), 3);
  assertEq("F2 1, 5", fuel2(1, 5), 10);
  assertEq("F2 2, 5", fuel2(2, 5), 6);
  assertEq("F2 14, 5", fuel2(14, 5), 45);
  my @test_cases =
    (
     [ "test1.txt", 168 ],
     [ "input.txt", 95167302 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[-1]);
  }
}
