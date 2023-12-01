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
  my %g;
  for my $l (@$lines) {
    my ($o, $c) = split /\)/, $l, 2;
    $g{$c}->{p} = $o;
  }
  return \%g;
}

no warnings 'recursion'; # global but here as this is where it matters
sub parents {
  my ($g, $o) = @_;
  unless (exists $g->{$o}) {
    return {}
  }
  unless (exists $g->{$o}->{pc}) {
    my %s;
    my $p = $g->{$o}->{p};
    $s{$p} = 0;
    my $parents = parents($g, $p);
    for my $pp (keys %$parents) {
      $s{$pp} = $parents->{$pp}+1;
    }
    $g->{$o}->{pc} = \%s;
  }
  return $g->{$o}->{pc};
}

sub calc {
  my ($g) = @_;
  my $s = 0;
  foreach my $o (keys %$g) {
    $s += keys %{parents($g, $o)};
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
  my $p1 = parents($g, 'SAN');
  my $p2 = parents($g, 'YOU');
  my $min;
  for my $o (keys %$p1) {
    next unless (exists $p2->{$o});
    my $d = $p1->{$o} + $p2->{$o};
    if (!defined $min || $min > $d) {
      $min = $d;
    }
  }
  return $min;
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
