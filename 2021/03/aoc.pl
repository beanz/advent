#!/usr/bin/env perl
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
  my $bits = (length $in->[0]);
  my $total = scalar @$in;
  $in = [map { oct("0b".$_) } @$in];
  my $g = 0;
  my $e;
  for (my $bit = 2**($bits-1); $bit >= 1; $bit /= 2) {
    my $c = 0;
    for my $l (@$in) {
      $c++ if ($l&$bit);
    }
    if ($c > ($total/2)) {
      $g += $bit;
    } else {
      $e += $bit;
    }
  }
  return $g*$e;
}

sub most_common {
  my ($in, $bit) = @_;
  my $c = 0;
  my $lines = scalar @$in;
  for my $l (@$in) {
    my @b = split //, $l;
    $c++ if ($b[$bit] == 1);
  }
  return ($c >= ($lines/2)) ? 1 : 0;
}

sub o2 {
  my ($in, $bit) = @_;
  my $keep = most_common($in, $bit);
  my @r;
  for my $l (@$in) {
    my @b = split //, $l;
    if ($b[$bit] == $keep) {
      push @r, $l;
    }
  }
  return \@r;
}

sub co2 {
  my ($in, $bit) = @_;
  my $keep = 1-most_common($in, $bit);
  my @r;
  for my $l (@$in) {
    my @b = split //, $l;
    if ($b[$bit] == $keep) {
      push @r, $l;
    }
  }
  return \@r;
}

sub calc2 {
  my ($in) = @_;
  my $bits = length $in->[0];
  my $o2 = $in;
  for my $bit (0..$bits) {
    $o2 = o2($o2, $bit);
    if (1 == scalar @$o2) {
      last;
    }
  }
  my $co2 = $in;
  for my $bit (0..$bits) {
    $co2 = co2($co2, $bit, 0);
    if (1 == scalar @$co2) {
      last;
    }
  }
  $o2 = oct("0b".$o2->[0]);
  $co2 = oct("0b".$co2->[0]);
  return $o2 * $co2;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 198 ],
     [ "input.txt", 749376 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 230, ],
     [ "input.txt", 2372923 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
