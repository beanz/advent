#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /-/, $lines->[0]];
}

sub calc {
  my ($p, $part) = @_;
  $part //= 1;
  my $c = 0;
  for my $i ($p->[0]..$p->[1]) {
    next unless (length $i == 6);
    next unless ($i =~ /(.)\1/);
    next unless ($i eq (join '', sort { $a <=> $b } split //, $i));
    $c++;
  }
  return $c;
}

if (TEST) {
  my @test_cases =
    (
     [ 111111, 1 ],
     [ 223450, 0 ],
     [ 123789, 0 ],
     [ 123444, 1 ],
     [ 111122, 1 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input([$tc->[0]."-".$tc->[0]]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($p, $part) = @_;
  $part //= 1;
  my $c = 0;
  for my $i ($p->[0]..$p->[1]) {
    next unless (length $i == 6);
    next unless ($i eq (join '', sort { $a <=> $b } split //, $i));
    next unless ($i =~ /^(?:.*(.)((?!\1).)\2(?!\2)|(.)\3(?!\3))/);
    $c++;
  }
  return $c;
}

if (TEST) {
  my @test_cases =
    (
     [ 112233, 1 ],
     [ 123444, 0 ],
     [ 111122, 1 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(parse_input([$tc->[0]."-".$tc->[0]]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
