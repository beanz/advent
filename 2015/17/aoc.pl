#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant {
  LEFT => 0,
  PICKED => 1,
};

my @i = @{read_lines(shift//"input.txt")};

sub pp {
  my ($array_of_arrays) = @_;
  my $r = '';
  return (join ', ', map { '['.(join ',', @{$_}).']' } @$array_of_arrays)."\n";
}

sub all_combinations {
  my ($k, $remaining, $prefix) = @_;
  print STDERR "AC: $remaining from @$k\n" if DEBUG;
  my @todo = ([$k, []]);
  my @res;
  while (@todo) {
    my $next = shift @todo;
    print "Checking ", pp($next) if DEBUG;
    my @left = @{$next->[LEFT]};
    my $sum = sum(@{$next->[PICKED]}) // 0;
    unless (@left) {
      if ($remaining == $sum) {
        print STDERR "  valid set ", (join ',', @{$next->[PICKED]}), "\n"
          if DEBUG;
        push @res, $next->[PICKED];
      } else {
        print STDERR "  too small set ", (join ',', @{$next->[PICKED]}), "\n"
          if DEBUG;
      }
      next;
    }
    my $cap = shift @left;
    if (($cap + $sum) == $remaining) {
      print STDERR "  valid set $cap,", (join ',', @{$next->[PICKED]}), "\n"
        if DEBUG;
      push @res, [$cap, @{$next->[PICKED]}];
    } elsif (($cap + $sum) < $remaining) {
      print STDERR "  adding $cap and @{$next->[PICKED]}\n" if DEBUG;
      push @todo, [ [@left], [$cap, @{$next->[PICKED]}] ];
    }
    print STDERR "  adding @{$next->[PICKED]}\n" if DEBUG;
    push @todo, [ [@left], [@{$next->[PICKED]}] ];
  }
  return \@res;
}

sub calc {
  my ($i, $cap) = @_;
  my $combinations = all_combinations($i, $cap);
  print STDERR pp($combinations) if DEBUG;
  return $combinations;
}

my @test_input = split/\n/, <<'EOF';
20
15
10
5
5
EOF
chomp @test_input;

my $test_res;
if (TEST) {
  $test_res = calc(\@test_input, 25);
  my $num = @$test_res;
  assertEq("Test 1", $num, 4);
}

my $part1 = calc(\@i, 150);
my $num = @$part1;
print "Part 1: $num\n";

sub calc2 {
  my ($i) = @_;
  my $min = min(map { scalar @$_ } @$i) // 0;
  return ~~grep { $min == scalar @$_ } @$i;
}

if (TEST) {
  assertEq('Test 2', calc2($test_res), 3);
}
print "Part 2: ", calc2($part1), "\n";
