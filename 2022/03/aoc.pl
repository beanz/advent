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
#my $reader = \&read_stuff;
my $reader = \&read_guess;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub priority {
  my $k = shift;
  my $o = ord($k);
  my $p = $o > 90 ? 1+$o-97 : 27+$o - 65;
  return $p;
}

sub common {
  my ($a, $b, $c) = @_;
  my %a = map { $_ => 1 } split //, $a;
  my %b = map { $_ => 1 } split //, $b;
  my %c = map { $_ => 1 } split //, $c//"";
  foreach my $k (keys %a) {
    if (exists $b{$k} && (!defined $c || exists $c{$k})) {
      return $k;
    }
  }
}

sub halve {
  my ($l) = @_;
  my ($b) = substr $l, 0, length($l)/2, "";
  return ($l, $b)
}

sub calc {
  my ($in, $fn) = @_;
  my $c = 0;
  for my $l (@$in) {
    $c += priority(common(halve($l)));
  }
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  while (my @a = splice @$in, 0, 3) {
    $c += priority(common(@a));
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
     [ "test1.txt", 157 ],
     [ "input.txt", 7428 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 70 ],
     [ "input.txt", 2650 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
