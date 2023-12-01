#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = @{read_lines(shift//"input.txt")};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /, /, $lines->[0]];
}

sub calc {
  my ($i, $part) = @_;
  $part //= 1;
  my $dir = compassOffset('N');
  my ($ox, $oy) = (0, 0);
  my ($x, $y) = ($ox, $oy);
  my $vc = visit_checker();
  for my $move (@$i) {
    printf STDERR "facing %s, move %s, ", offsetCompass(@$dir), $move if DEBUG;
    my ($turn, $steps) = ($move =~ /^([RL])(\d+)$/);
    $dir = $turn eq 'R' ? offsetCW(@$dir) : offsetCCW(@$dir);
    printf STDERR "turning %s to %s, $steps steps to %d,%d\n",
      $turn, offsetCompass(@$dir), $x+$dir->[X]*$steps, $y+$dir->[Y]*$steps
      if DEBUG;
    for my $s (1 .. $steps) {
      $x += $dir->[X];
      $y += $dir->[Y];
      if ($part == 2) {
        if ($vc->($x, $y)) {
          return manhattanDistance([$ox, $oy], [$x, $y]);
        }
      }
    }
  }
  return manhattanDistance([$ox,$oy], [$x, $y]);
}

if (TEST) {
  my @test_cases =
    (
     [ "R2, L3", 5 ],
     [ "R2, R2, R2", 2 ],
     [ "R5, L5, R5, R3", 12 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input([$tc->[0]]));
    assertEq('Test 1 '.$tc->[0], $tc->[1], $res);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i) = @_;
  return calc($i, 2);
}

if (TEST) {
  my @test_cases =
    (
     [ "R8, R4, R4, R8", 4],
    );
  for my $tc (@test_cases) {
    my $res = calc2(parse_input([$tc->[0]]));
    assertEq('Test 2 '.$tc->[0], $tc->[1], $res);
  }
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
