#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = @{read_lines(shift//"input.txt")};

my $i = parse_input(\@i);
#dd([$i],[qw/i/]);

sub parse_input {
  my ($lines) = @_;
  return $lines;
}

sub calc {
  my ($lines) = @_;
  my $count = 0;
  for my $l (@$lines) {
    $l =~ s/^\s+//;
    my ($a, $b, $c) = sort { $a <=> $b } split /\s+/, $l;
    $count++ if ($a + $b > $c);
  }
  return $count;
}

if (TEST) {
  my $test_input;
  $test_input = parse_input([split/\n/, <<'EOF']);
 5  10 25
EOF
  my $res;
  $res = calc($test_input);
  assertEq("Test 1", $res, 0);
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub valid {
  my (@a) = @_;
  my ($a, $b, $c) = sort { $a <=> $b } @a;
  return $a + $b > $c;
}

sub calc2 {
  my ($lines) = @_;
  my $count = 0;
  my $i = 0;
  while (@$lines) {
    my $l = shift @$lines;
    $l =~ s/^\s+//;
    my ($a1, $b1, $c1) = split /\s+/, $l;
    $l = shift @$lines;
    $l =~ s/^\s+//;
    my ($a2, $b2, $c2) = split /\s+/, $l;
    $l = shift @$lines;
    $l =~ s/^\s+//;
    my ($a3, $b3, $c3) = split /\s+/, $l;
    $count++ if (valid($a1, $a2, $a3));
    $count++ if (valid($b1, $b2, $b3));
    $count++ if (valid($c1, $c2, $c3));
  }
  return $count;
}

if (TEST) {
  my $test_input;
  $test_input = parse_input([split/\n/, <<'EOF']);
 5  10 25
10  15 30
25  20  6
EOF
  my $res;
  $res = calc2($test_input);
  assertEq("Test 2", $res, 2);
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
