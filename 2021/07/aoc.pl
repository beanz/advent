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

sub read_stuff {
  my $file = shift;
  return [sort { $a <=> $b } split/,/, read_lines($file)->[0] ];
}

sub fuel {
  my ($a, $b) = @_;
  return abs($a - $b);
}

sub fuel2 {
  my ($a, $b) = @_;
  my $f = abs($a - $b);
  return $f*($f+1)/2;
}

sub calc {
  my ($in) = @_;
  return sum(map { fuel($in->[int(@$in/2)], $_) } @$in);
}

sub min_fuel {
  my ($in) = @_;
  my ($mean) = int(sum(@$in)/@$in);
  return min(map { my $v = $mean+$_; sum(map { fuel2($v, $_) } @$in) } 0..1);
}

sub calc2 {
  return min_fuel($_[0]);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 37 ],
     [ "test2.txt", 251456 ],
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
     [ "test2.txt", 42005848 ],
     [ "input.txt", 95167302 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[-1]);
  }
}
