#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub calc {
  my ($p, $part) = @_;
  $part //= 1;
  return 1;
}

if (TEST) {
  my @test_cases =
    (
     [ ["1"], 1 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input($tc->[0]));
    assertEq("Test 1 [@{$tc->[0]}]", $res, $tc->[1]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i) = @_;
  return 2;
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
