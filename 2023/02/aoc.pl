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

my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub parts {
  my ($in) = @_;
  my ($p1, $p2) = (0, 0);
  for (@$in) {
    /^Game (\d+): (.*)$/ || die "bad input? $_\n";
    my ($id, $rest) = ($1, $2);
    my $possible = 1;
    my %m = (map {$_ => 1} qw/red blue green/);
    for my $set (split /;\s*/, $rest) {
      my %r = (map {$_ => 0} qw/red blue green/);
      for my $r (split /,\s*/, $set) {
        my ($n, $c) = split / /, $r;
        $r{$c} = $n;
        $m{$c} = $r{$c} if ($m{$c} < $r{$c});
      }
      if ($r{red} > 12 || $r{green} > 13 || $r{blue} > 14) {
        $possible = undef;
      }
    }
    if ($possible) {
      $p1 += $id;
    }
    $p2 += $m{red} * $m{green} * $m{blue};
  }
  return [$p1, $p2];
}

testParts() if (TEST);

my $r = parts($i);
print "Part 1: ", $r->[0], "\n";
print "Part 2: ", $r->[1], "\n";

sub testParts {
  my @test_cases = (["test1.txt", 8, 2286], ["input.txt", 2101, 58269],);
  for my $tc (@test_cases) {
    my $res = parts($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}