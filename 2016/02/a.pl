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
  return $lines;
}

my %moves =
  (
   '1' => { 'U' => '1', 'D' => 4, 'L' => 1, 'R' => 2 },
   '2' => { 'U' => '2', 'D' => 5, 'L' => 1, 'R' => 3 },
   '3' => { 'U' => '3', 'D' => 6, 'L' => 2, 'R' => 3 },
   '4' => { 'U' => '1', 'D' => 7, 'L' => 4, 'R' => 5 },
   '5' => { 'U' => '2', 'D' => 8, 'L' => 4, 'R' => 6 },
   '6' => { 'U' => '3', 'D' => 9, 'L' => 5, 'R' => 6 },
   '7' => { 'U' => '4', 'D' => 7, 'L' => 7, 'R' => 8 },
   '8' => { 'U' => '5', 'D' => 8, 'L' => 7, 'R' => 9 },
   '9' => { 'U' => '6', 'D' => 9, 'L' => 8, 'R' => 9 },
  );

sub calc {
  my ($i, $m) = @_;
  $m //= \%moves;
  my $key = 5;
  my $res = '';
  for my $l (@$i) {
    for my $c (split //, $l) {
      my $n = $m->{$key}->{$c} or die "Invalid direction $c from $key\n";
      print STDERR "Moved $c from $key to $n\n" if DEBUG;
      $key = $n;
    }
    $res .= $key;
  }
  return $res;
}

my $test_input;
$test_input = parse_input([split/\n/, <<'EOF']);
ULL
RRDDD
LURDL
UUUUD
EOF

if (TEST) {
  my $res;
  $res = calc($test_input);
  assertEq("Test 1", $res, "1985");
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

my %moves2 =
  (
   '1' => { 'U' => '1', 'D' => '3', 'L' => '1', 'R' => '1' },
   '2' => { 'U' => '2', 'D' => '6', 'L' => '2', 'R' => '3' },
   '3' => { 'U' => '1', 'D' => '7', 'L' => '2', 'R' => '4' },
   '4' => { 'U' => '4', 'D' => '8', 'L' => '3', 'R' => '4' },
   '5' => { 'U' => '5', 'D' => '5', 'L' => '5', 'R' => '6' },
   '6' => { 'U' => '2', 'D' => 'A', 'L' => '5', 'R' => '7' },
   '7' => { 'U' => '3', 'D' => 'B', 'L' => '6', 'R' => '8' },
   '8' => { 'U' => '4', 'D' => 'C', 'L' => '7', 'R' => '9' },
   '9' => { 'U' => '9', 'D' => '9', 'L' => '8', 'R' => '9' },
   'A' => { 'U' => '6', 'D' => 'A', 'L' => 'A', 'R' => 'B' },
   'B' => { 'U' => '7', 'D' => 'D', 'L' => 'A', 'R' => 'C' },
   'C' => { 'U' => '8', 'D' => 'C', 'L' => 'B', 'R' => 'C' },
   'D' => { 'U' => 'B', 'D' => 'D', 'L' => 'D', 'R' => 'D' },
  );

sub calc2 {
  my ($i) = @_;
  return calc($i, \%moves2);
}

if (TEST) {
  my $res;
  $res = calc2($test_input);
  assertEq("Test 1", $res, "5DB3");
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
