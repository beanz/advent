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
  my ($i, $me) = @_;
  my %p;
  foreach my $l (@$i) {
    die "bad line: $l\n"
      unless ($l=~ /(.*) would (gain|lose) (\d+) happiness .* to (.*)\./);
    $p{$1}->{$4} = $3 * ($2 eq 'gain' ? 1 : -1);
    if (defined $me) {
      $p{$me}->{$1} = 0;
      $p{$me}->{$4} = 0;
      $p{$1}->{$me} = 0;
      $p{$4}->{$me} = 0;
    }
  }
  my @all_arrangements = permutations([keys %p]);
  my $max = -1000000;
  for my $arrangement (@all_arrangements) {
    my $happiness = 0;
    for my $i (0..(scalar @$arrangement)-1) {
      my $person = $arrangement->[$i];
      my $left = $arrangement->[($i-1)%@$arrangement];
      my $right = $arrangement->[($i+1)%@$arrangement];
      $happiness += $p{$person}->{$left};
      $happiness += $p{$person}->{$right};
    }
    $max = max($happiness,$max);
  }
  return $max;
}

my @test_input = split/\n/, <<'EOF';
Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
EOF
chomp @test_input;

if (TEST) {
  my $res = calc(\@test_input);
  print "Test 1: $res == 330\n";
}
print "Part 1: ", calc(\@i), "\n";
print "Part 2: ", calc(\@i, 'Me'), "\n";
