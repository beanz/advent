#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Graph;

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  my $g = Graph->new;
  for my $l (@$lines) {
    my ($o, $c) = split /\)/, $l, 2;
    $g->add_edge($c, $o);
  }
  return $g;
}

sub calc {
  my ($g) = @_;
  my $s = 0;
  foreach my $v ($g->vertices()) {
    $s += $g->all_successors($v);
  }
  return $s;
}

if (TEST) {
  my @test_cases =
    (
     [ [qw/COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L/], 42 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input($tc->[0]));
    assertEq("Test 1 [@{$tc->[0]}]", $res, $tc->[1]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($g) = @_;
  my @p = $g->undirected_copy->SP_Dijkstra('YOU','SAN');
  return @p - 3;
}

if (TEST) {
  my @test_cases =
    (
     [ [qw/COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L K)YOU I)SAN/], 4 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(parse_input($tc->[0]));
    assertEq("Test 2 [@{$tc->[0]}]", $res, $tc->[1]);
  }
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
