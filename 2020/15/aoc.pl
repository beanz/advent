#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);
my $i2 = read_lines($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

sub calc {
  my ($lines, $turn) = @_;
  $turn //= 2020;
  my @n = split /,/, $lines->[0];
  my @lastSeen;
  my $n;
  my $p;
  for my $t (1..@n) {
    $n = $n[$t-1];
    if ($t > 1) {
      $lastSeen[$p] = $t;
    }
    $p = $n;
  }
  for my $t ((@n+1)..$turn) {
    if (defined $lastSeen[$p]) {
      $n = $t - $lastSeen[$p];
    } else {
      $n = 0;
    }
    $lastSeen[$p] = $t;
    $p = $n;
  }
  # print scalar(grep defined $_, @lastSeen), "\n";
  return $n;
}

sub calc2 {
  my ($in) = @_;
  return calc($in, 30000000);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 436 ],
     [ "test2.txt", 1 ],
     [ "test3.txt", 10 ],
     [ "test4.txt", 27 ],
     [ "test5.txt", 78 ],
     [ "test6.txt", 438 ],
     [ "test7.txt", 1836 ],
     [ "input.txt", 260 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 175594 ],
     [ "test2.txt", 2578 ],
     [ "test3.txt", 3544142 ],
     [ "test4.txt", 261214 ],
     [ "test5.txt", 6895259 ],
     [ "test6.txt", 18 ],
     [ "test7.txt", 362 ],
     [ "input.txt", 950 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
