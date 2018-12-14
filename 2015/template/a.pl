#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use List::Util qw/min max minstr maxstr sum product pairs/;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
  TEST => $ENV{AoC_TEST},
};

my @i = <>;
chomp @i;

sub calc {
  my ($i) = @_;
  return @$i;
}

my @test_input = split/\n/, <<'EOF';
EOF
chomp @test_input;

if (TEST) {
  print "Test 1: ", calc(\@test_input), " == 0\n";
}
print "Part 1: ", calc(\@i), "\n";

sub calc2 {
  my ($i) = @_;
  return @$i;
}

if (TEST) {
  print "Test 2: ", calc2(\@test_input), " == 0\n";
}
print "Part 2: ", calc2(\@i), "\n";
