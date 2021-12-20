#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_stuff;
#my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m = ( lines => $in );
  for my $i (0..(@$in-1)) {
    my $l = $in->[$i];
    print "$i: $l\n";
  }
  return \%m;
}

sub calc {
  my ($in) = @_;
  dd([$in],[qw/in/]);
  my $c = 0;
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 10 ],
     [ "input.txt", 307 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 1, 15 ],
     [ "test1.txt", 2, 12 ],
     [ "test1.txt", 10, 37 ],
     [ "test1.txt", 100, 2208 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 2 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}
