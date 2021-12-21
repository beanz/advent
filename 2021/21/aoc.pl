#!/usr/bin/perl
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
my $reader = \&read_stuff;
#my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

use constant
  {
   POS => 0,
   SCORE => 1,
   WAYS => 2,
  };

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @pl;
  for my $i (0..(@$in-1)) {
    my $l = $in->[$i];
    #print "$i: $l\n";
    my @p = ($l =~ m!(\d+)!mg);
    push @pl, [ $p[1], 0 ];
  }
  return \@pl;
}

my $dice = 0;

sub roll {
  my $r = $dice;
  $dice++;
  return ($r%100)+1;
}

sub move {
  my ($p, $r) = @_;
  $p->[POS] += $r;
  while ($p->[POS] > 10) { $p->[POS] -= 10; }
  $p->[SCORE] += $p->[POS];
  return $p->[POS];
}

sub plgo {
  my ($p) = @_;
  my $r = roll() + roll() + roll();
  return move($p, $r);
}

sub pp {
  my ($pl) = @_;
  for (0..1) {
    printf "Player %d moves to space %d for a total score of %d.\n",
      $_+1, $pl->[$_]->[POS], $pl->[$_]->[SCORE];
  }
}

sub calc {
  my ($pl) = @_;
  $dice = 0;
  while (1) {
    for (0..1) {
      plgo($pl->[$_]);
      if ($pl->[$_]->[SCORE] >= 1000) {
        return $pl->[1-$_]->[SCORE] * $dice;
      }
    }
    #pp($pl);
    #last;
  }
}

my %ways = ();
for my $a (1..3) {
  for my $b (1..3) {
    for my $c (1..3) {
      $ways{$a+$b+$c}++;
    }
  }
}

sub wins {
  state %cache;
  my ($p1, $s1, $p2, $s2) = @_;
  if ($s1 >= 21) {
    return (1,0);
  }
  if ($s2 >= 21) {
    return (0,1);
  }
  my $k = "$p1,$s1,$p2,$s2";
  return @{$cache{$k}} if ($cache{$k});
  my @wins = (0,0);
  for my $roll (keys %ways) {
    my $np1 = $p1+$roll;
    while ($np1 > 10) { $np1-=10 }
    my $ns1 = $s1 + $np1;
    my @w = wins($p2, $s2, $np1, $ns1);
    $wins[1] += $w[0] * $ways{$roll};
    $wins[0] += $w[1] * $ways{$roll};
  }
  $cache{$k} = \@wins;
  return @wins;
}
sub calc2 {
  my ($pl) = @_;
  my @wins = wins($pl->[0]->[POS], 0, $pl->[1]->[POS], 0);
  return max(@wins);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 739785 ],
     [ "input.txt", 428736 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 444356092776315 ],
     [ "input.txt", 57328067654557 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
