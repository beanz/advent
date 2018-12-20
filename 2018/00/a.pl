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
#dd([$i],[qw/i/]);

sub parse_input {
  my ($lines) = @_;
  my %s;

  return \%s;
}

sub calc {
  my ($i) = @_;
  return ~~keys %$i;
}

my $test_input;
$test_input = parse_input([split/\n/, <<'EOF']);
EOF
#dd([$test_input],[qw/test_input/]);

if (TEST) {
  my $res;
  $res = calc($test_input);
  assertEq("Test 1", $res, "foo");
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i) = @_;
  return ~~keys %$i;
}

if (TEST) {
  my $res;
  $res = calc2($test_input);
  assertEq("Test 2", $res, "bar");
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
