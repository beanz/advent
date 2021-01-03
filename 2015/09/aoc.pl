#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use Algorithm::Combinatorics qw(permutations);
use List::Util qw/min max minstr maxstr sum product pairs/;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
  TEST => $ENV{AoC_TEST},
};

my @i = <>;
chomp @i;

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
  print "Test 1: ", calc(\@test_input), " == 605\n";
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
  print "Test 2: ", calc2(\@test_input), " == 982\n";
}
print "Part 2: ", calc2(\@i), "\n";
