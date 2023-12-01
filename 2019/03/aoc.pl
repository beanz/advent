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

sub path {
  my ($line) = @_;
  my %p;
  my ($x,$y) = (0,0);
  my $steps = 0;
  foreach my $m (split /,/, $line) {
    my ($d, $c) = ($m =~ /^([RLDU])(\d+)$/);
    my $offset =
      {
       'R' => [1, 0],
       'L' => [-1, 0],
       'D' => [0, 1],
       'U' => [0, -1],
      }->{$d};
    for (1..$c) {
      $x += $offset->[X];
      $y += $offset->[Y];
      $steps++;
      $p{hk($x,$y)} = $steps;
    }
  }
  return \%p;
}

sub calc {
  my ($lines, $part) = @_;
  $part //= 1;
  my %m;

  my $p1 = path($lines->[0]);
  my $p2 = path($lines->[1]);
  my $dist;
  my $steps;
  for my $p (keys %$p1) {
    if (exists $p2->{$p}) {
      my $d = manhattanDistance([0,0],kh($p));
      if (!defined $dist || $d < $dist) {
        $dist = $d;
      }
      my $s = $p1->{$p} + $p2->{$p};
      if (!defined $steps || $s < $steps) {
        $steps = $s;
      }
    }
  }
  return [$dist, $steps];
}

if (TEST) {
  my @test_cases =
    (
     [ ["R8,U5,L5,D3", "U7,R6,D4,L4"], 6, 30 ],
     [ ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
        "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7" ], 135, 410 ],
     [ ["R75,D30,R83,U83,L12,D49,R71,U7,L72",
        "U62,R66,U55,R34,D71,R55,D58,R83"], 159, 610 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input($tc->[0]));
    assertEq("Test 1 [@{$tc->[0]}]", $res->[0], $tc->[1]);
    assertEq("Test 2 [@{$tc->[0]}]", $res->[1], $tc->[2]);
  }
}

my $res = calc($i);
my $part1 = $res->[0];
print "Part 1: ", $part1, "\n";
print "Part 2: ", $res->[1], "\n";
