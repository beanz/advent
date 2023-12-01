#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);
my %seen;
my %pairs;

sub calc {
  my ($i) = @_;
  my $res;
  for my $a (@$i) {
    my $rem = 2020-$a;
    if ($seen{$rem}) {
      $res = $a * $rem;
    }
    $pairs{$a+$_} = $a*$_ for (keys %seen);
    $seen{$a}++;
  }
  return $res;
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
  my ($i) = @_;
  for my $a (@$i) {
    my $rem = 2020 - $a;
    if (exists $pairs{$rem}) {
      return $a * $pairs{$rem};
    }
  }
  return;
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
