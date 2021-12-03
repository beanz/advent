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
  my $c = 0;
  my @c;
  my $lines = scalar @$in;
  for my $l (@$in) {
    my @b = split //, $l;
    for my $i (0..$#b) {
      $c[$i]++ if ($b[$i] == 1);
    }
  }
  my $g = "";
  my $e = "";
  for my $i (0..$#c) {
    if ($c[$i] > ($lines/2)) {
      $g .= "1";
      $e .= "0";
    } else {
      $g .= "0";
      $e .= "1";
    }
  }
  $g = oct("0b".$g);
  $e = oct("0b".$e);
  return $g*$e;
}

sub most {
  my ($in, $bit, $val) = @_;
  my $c = 0;
  my $lines = scalar @$in;
  for my $l (@$in) {
    my @b = split //, $l;
    $c++ if ($b[$bit] == $val);
  }
  my @r;
  my $keep;
  if ($val) {
    $keep = ($c >= ($lines/2)) ? $val : (1-$val);
  } else {
    $keep = ($c <= ($lines/2)) ? $val : (1-$val);
  }
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
    $o2 = most($o2, $bit, 1);
    if (1 == scalar @$o2) {
      last;
    }
  }
  my $co2 = $in;
  for my $bit (0..$bits) {
    $co2 = most($co2, $bit, 0);
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
