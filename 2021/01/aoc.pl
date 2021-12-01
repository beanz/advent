#!/usr/bin/perl
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
  my $p;
  my $c = 0;
  for my $n (@$in) {
    $c++ if (defined $p && $p < $n);
    $p = $n;
  }
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  my $p;
  for my $i (2 ..(scalar @$in - 1)) {
    my $n = $in->[$i-2] + $in->[$i-1] + $in->[$i];
    $c++ if (defined $p && $p < $n);
    $p = $n;
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test.txt", 7 ],
     [ "input.txt", 1342 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test.txt", 5, ],
     [ "input.txt", 1378 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
