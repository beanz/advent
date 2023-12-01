#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw(permutations);

my @i = @{read_lines(shift//"input.txt")};

sub calc {
  my ($i) = @_;
  my %dist;
  for my $l (@$i) {
    my ($c1, $c2, $d) = ($l =~ /(\w+) to (\w+) = (\d+)/) or die;
    $dist{$c1}->{$c2} = $d;
    $dist{$c2}->{$c1} = $d;
  }
  my @all_routes = permutations([keys %dist]);
  return min(map {
    my $d = 0;
    for my $i (0..@$_ - 2) {
      $d += $dist{$_->[$i]}->{$_->[$i+1]};
    }
    $d
  } @all_routes);
}

my @test_input = split/\n/, <<'EOF';
London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141
EOF
chomp @test_input;

if (TEST) {
  assertEq("Test 1", calc(\@test_input), 605);
}

print "Part 1: ", calc(\@i), "\n";

sub calc2 {
  my ($i) = @_;
  my %dist;
  for my $l (@$i) {
    my ($c1, $c2, $d) = ($l =~ /(\w+) to (\w+) = (\d+)/) or die;
    $dist{$c1}->{$c2} = $d;
    $dist{$c2}->{$c1} = $d;
  }
  my @all_routes = permutations([keys %dist]);
  return max(map {
    my $d = 0;
    for my $i (0..@$_ - 2) {
      $d += $dist{$_->[$i]}->{$_->[$i+1]};
    }
    $d
  } @all_routes);
}

if (TEST) {
  assertEq("Test 2", calc2(\@test_input), 982);
}

print "Part 2: ", calc2(\@i), "\n";
