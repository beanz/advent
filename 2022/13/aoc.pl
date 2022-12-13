#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_chunks($file);
  my @p= map { [ map { [$_, eval $_] } split/\n/, $_] } @$in;
  return \@p;
}

sub comp {
  my ($l, $r) = @_;
  if (defined $l && !defined $r) {
    return 1;
  } elsif (!defined $l && defined $r) {
    return -1;
  } elsif (!ref $l && !ref $r) {
    return ($l <=> $r);
  } elsif (ref $l && ref $r) {
    for my $i (0..@$l-1) {
      my $cmp = comp($l->[$i], $r->[$i]);
      if ($cmp != 0) {
        return $cmp;
      }
    }
    return @$l <=> @$r;
  } elsif (ref $l) {
    return comp($l, [$r]);
  } else {
    return comp([$l], $r);
  }
}

sub calc {
  my ($in) = @_;
  my $c = 0;
  for my $i (0..@$in-1) {
    my ($l, $r) = @{$in->[$i]};
    my $cmp = comp($l->[1], $r->[1]);
    $c+=($i+1) if ($cmp == -1);
  }
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my @p;
  for my $pair (@$in) {
    push @p, $pair->[0], $pair->[1];
  }
  push @p, ["[[2]]", [[2]]], ["[[6]]", [[6]]];
  my @r = sort { comp($a->[1], $b->[1]) } @p;
  my $c = 1;
  for my $i (0..$#r) {
    $c *= ($i+1) if ($r[$i]->[0] eq "[[2]]" || $r[$i]->[0] eq "[[6]]");
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 13 ],
     [ "input.txt", 5350 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 140 ],
     [ "input.txt", 19570 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
