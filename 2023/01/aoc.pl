#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

use Carp::Always qw/carp verbose/;

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
  my %m = (lines => $in);
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    print "$i: $l\n";
  }
  return \%m;
}

sub calc {
  my ($in) = @_;
  my $c = 0;
  for (@$in) {
    if (/^[\D]*(\d).*(\d)\D*$/) {
      $c += $1 . $2;
    } elsif (/(\d)/) {
      $c += $1 . $1;
    }
  }
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  for (@$in) {
    my $n = 0;
    if (
/^[\D]*?(\d|one|two|three|four|five|six|seven|eight|nine).*(\d|one|two|three|four|five|six|seven|eight|nine)\D*$/
      )
    {
      $n = $1 . $2;
    } elsif (/(\d|one|two|three|four|five|six|seven|eight|nine)/) {
      $n = $1 . $1;
    }
    $n =~ s/one/1/g;
    $n =~ s/two/2/g;
    $n =~ s/three/3/g;
    $n =~ s/four/4/g;
    $n =~ s/five/5/g;
    $n =~ s/six/6/g;
    $n =~ s/seven/7/g;
    $n =~ s/eight/8/g;
    $n =~ s/nine/9/g;
    $c += $n;
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 142], ["input.txt", 54390],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test2.txt", 281], ["input.txt", 54277],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
