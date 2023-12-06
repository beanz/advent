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

my $reader = \&read_guess;
my $i = $reader->($file);

sub race {
  my ($t, $r) = @_;
  my $c = 0;
  for my $h (1 .. $t - 1) {
    my $d = ($t - $h) * $h;
    $c++ if ($d > $r);
  }
  return $c;
}

sub calc {
  my ($in) = @_;
  my $p1 = 1;
  my ($r, $t) = ("", "");
  for my $i (1 .. @{$in->[0]} - 1) {
    $r .= $in->[0]->[$i];
    $t .= $in->[1]->[$i];
    my $c = race($in->[0]->[$i], $in->[1]->[$i]);
    $p1 *= $c if ($c);
  }
  return [$p1, race($r, $t)];
}

testParts() if (TEST);

my $r = calc($i);
print "Part 1: $r->[0]\nPart 2: $r->[1]\n";

sub testParts {
  my @test_cases =
    (["test1.txt", 288, 71516], ["input.txt", 5133600, 40651271],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[2]);
  }
}
