#!/usr/bin/env perl
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
my $reader = \&read_guess;
my $i = $reader->($file);

sub calc {
  my ($in) = @_;
  #dd([$in],[qw/in/]);
  my @r = map { sum @$_ } @$in;
  my @c = sort { $b <=> $a } @r;
  return [$c[0], $c[0]+$c[1]+$c[2]]
}

testParts() if (TEST);

my $p = calc($i);
print "Part 1: ", $p->[0], "\n";
print "Part 2: ", $p->[1], "\n";

sub testParts {
  my @test_cases =
    (
     [ "test1.txt", 24000, 45000 ],
     [ "input.txt", 66487, 197301 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
