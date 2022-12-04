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
my $reader = \&read_guess;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  #dd([$in],[qw/in/]);
  my $c1 = 0;
  my $c2 = 0;
  for my $p (@$in) {
    my ($l0,$h0) = split/-/,$p->[0];
    my ($l1,$h1) = split/-/,$p->[1];
    $c1++ if ($l0 >= $l1 && $h0 <= $h1 || $l1 >= $l0 && $h1 <= $h0);
    $c2++ unless ($h0 < $l1 || $h1 < $l0);
  }
   
  return [$c1, $c2];
}

testParts() if (TEST);

my $res = calc($i);
print "Part 1: ", $res->[0], "\n";
print "Part 2: ", $res->[1], "\n";

sub testParts {
  my @test_cases =
    (
     [ "test1.txt", 2, 4 ],
     [ "input.txt", 584, 933 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
