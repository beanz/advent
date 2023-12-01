#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return $lines;
}

sub calc {
  my ($i, $part) = @_;
  $part //= 1;
  my $s = 0;
  for my $m (@$i) {
    $s += fuel($m);
  }
  return $s;
}

if (TEST) {
  my @test_cases =
    (
     [ [12], 2 ],
     [ [14], 2 ],
     [ [1969], 654 ],
     [ [100756], 33583 ],
     [ [12,14,1969,100756], 34241 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input($tc->[0]));
    assertEq("Test 1 [@{$tc->[0]}]", $res, $tc->[1]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i, $part) = @_;
  $part //= 1;
  my $s = 0;
  for my $m (@$i) {
    my $tm = $m;
    while (1) {
      my $f = fuel($tm);
      if ($f <= 0) {
        last;
      }
      $s += $f;
      $tm = $f;
    }
  }
  return $s;
}

sub fuel {
  return int($_[0]/3) - 2;
}

if (TEST) {
  my @test_cases =
    (
     [ [14], 2 ],
     [ [1969], 966 ],
     [ [100756], 50346 ],
     [ [12,14,1969,100756], 51316 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(parse_input($tc->[0]));
    assertEq("Test 2 [@{$tc->[0]}]", $res, $tc->[1]);
  }
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
