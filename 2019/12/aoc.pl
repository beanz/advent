#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/combinations/;

use constant
  {
   Z => 2,
   VX => 3,
   VY => 4,
   VZ => 5,
  };

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  my @moons;
  for my $l (@$lines) {
    die unless ($l =~ m!<x=([^,]+), y=([^,]+), z=([^,]+)>!);
    push @moons, [$1, $2, $3, 0, 0, 0];
  }
  return \@moons;
}

sub pp {
  my ($moons) = @_;
  my $s = "";
  for my $m (@$moons) {
    $s .=
      sprintf "pos=<x=%3d, y=%3d, z=%3d>, vel=<x=%3d, y=%3d, z=%3d>\n", @$m;
  }
  return $s;
}

sub step {
  my ($moons, $combinations) = @_;
  for my $c (@$combinations) {
    #print "@$c\n";
    my $m1 = $moons->[$c->[0]];
    my $m2 = $moons->[$c->[1]];
    for my $d (X, Y, Z) {
      if ($m1->[$d] > $m2->[$d]) {
        $m1->[VX+$d] -= 1;
        $m2->[VX+$d] += 1;
      } elsif ($m1->[$d] < $m2->[$d]) {
        $m1->[VX+$d] += 1;
        $m2->[VX+$d] -= 1;
      }
    }
  }
  for my $m (@$moons) {
    for my $d (X, Y, Z) {
      $m->[$d] += $m->[VX+$d];
    }
  }
}
sub calc {
  my ($moons, $steps) = @_;
  $steps //= 1000;
  print "After 0 steps:\n", pp($moons), "\n" if DEBUG;
  my @combinations = combinations([0..@$moons-1], 2);
  for my $step (1..$steps) {
    step($moons, \@combinations);
    print "After $step steps:\n", pp($moons), "\n" if DEBUG;
  }
  my $energy;
  for my $m (@$moons) {
    $energy += (abs($m->[X])+abs($m->[Y])+abs($m->[Z])) *
      (abs($m->[VX])+abs($m->[VY])+abs($m->[VZ]));
  }
  return $energy;
}

if (TEST) {
  my @test_cases =
    (
     [ "test1.txt", 10, 179 ],
     [ "test2.txt", 100, 1940 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input(read_lines($tc->[0])), $tc->[1]);
    assertEq("Test 1 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub axis {
  my ($moons, $axis) = @_;
  my $s = "";
  for my $m (@$moons) {
    $s .= sprintf "p=%d v=%d\n", $m->[$axis], $m->[VX+$axis];
  }
  return $s;
}

sub gcd {
  my ($a, $b) = @_;
  $a = abs($a);
  $b = abs($b);
  ($a,$b) = ($b,$a) if $a > $b;
  while ($a) {
    ($a, $b) = ($b % $a, $a);
  }
  return $b;
}

sub lcm {
  my ($a, $b) = @_;
  ($a && $b) and $a / gcd($a, $b) * $b or 0
}

sub calc2 {
  my ($moons) = @_;
  print "After 0 steps:\n", pp($moons), "\n" if DEBUG;
  my $steps = 0;
  my @cycle = (-1, -1, -1);
  my @initial;
  #my $start = time;
  for my $axis (X, Y, Z) {
    push @initial, axis($moons, $axis);
  }
  my @combinations = combinations([0..@$moons-1], 2);
  while ($cycle[X] == -1 || $cycle[Y] == -1 || $cycle[Z] == -1) {
    $steps++;
    step($moons, \@combinations);
    print "After $steps steps:\n", pp($moons), "\n" if DEBUG;
    for my $axis (X, Y, Z) {
      next unless ($cycle[$axis] == -1);
      if ($initial[$axis] eq axis($moons, $axis)) {
        print "Fount $axis cycle at $steps\n" if DEBUG;
        $cycle[$axis] = $steps;
      }
    }
  }
  my $lcm = lcm($cycle[0], $cycle[1]);
  $lcm = lcm($lcm, $cycle[2]);
  #print "Time: ", ($lcm * (time - $start) /
  #                 (365.25*86400 * $steps)), " years\n";
  return $lcm;
}

if (TEST) {
  my @test_cases =
    (
     [ "test1.txt", 2772 ],
     [ "test2.txt", 4686774924 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(parse_input(read_lines($tc->[0])));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
