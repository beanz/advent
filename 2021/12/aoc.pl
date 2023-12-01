#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';
my $file = shift // "input.txt";
my $reader = \&read_graph;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_graph {
  my $file = shift;
  my $in = read_lines($file);
  my $g = {};
  for (@$in) {
    my ($s, $e) = split/-/;
    push @{$g->{$s}}, $e;
    push @{$g->{$e}}, $s;
  }
  return $g;
}

sub aux {
  my ($g, $s, $e, $v, $p2, $tw) = @_;
  $v //={};
  if ($s eq $e) {
    return [[$e]];
  }
  $v->{$s}++ if ($s =~ /^[a-z]/);
  my @p;
  for my $n (@{$g->{$s}}) {
    if (exists $v->{$n}) {
      next unless (defined $p2);
      next if ($n eq "start");
      if (!defined $tw) {
        push @p, [ $s, @$_ ] for (@{aux($g, $n, $e, {%$v}, $p2, 1)});
      }
    } else {
      push @p, [ $s, @$_ ] for (@{aux($g, $n, $e, {%$v}, $p2, $tw)});
    }
  }
  return \@p;
}

sub calc {
  my ($in, $p2) = @_;
  my $ps = aux($in, 'start', 'end', {}, $p2);
  return scalar @$ps;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc($i2, 1), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 10 ],
     [ "test2.txt", 19 ],
     [ "test3.txt", 226 ],
     [ "input.txt", 4691 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 36 ],
     [ "test2.txt", 103 ],
     [ "test3.txt", 3509 ],
     [ "input.txt", 140718 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]), 1);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
