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
  #dd([$in],[qw/in/]);
  my $c = 0;
  my %s = (
    "AX" => 1+3,
    "AY" => 2+6,
    "AZ" => 3+0,
    "BX" => 1+0,
    "BY" => 2+3,
    "BZ" => 3+6,
    "CX" => 1+6,
    "CY" => 2+0,
    "CZ" => 3+3,
  );
  for my $r (@$in) {
    $c += $s{$r->[0].$r->[1]};
  }
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  my %s = (
    "AX" => 3+0,
    "AY" => 1+3,
    "AZ" => 2+6,
    "BX" => 1+0,
    "BY" => 2+3,
    "BZ" => 3+6,
    "CX" => 2+0,
    "CY" => 3+3,
    "CZ" => 1+6,
  );
  for my $r (@$in) {
    $c += $s{$r->[0].$r->[1]};
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
     [ "test1.txt", 15, ],
     [ "input.txt", 9651 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 12, ],
     [ "input.txt", 10560, ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
