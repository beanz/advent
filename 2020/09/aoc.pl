#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/combinations/;

my $file = shift // "input.txt";
my $i = read_lines($file);
#print dd([$i]); exit;
my $i2 = read_lines($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

sub calc {
  my ($in, $pre) = @_;
  $pre //= 25;
  for my $i ($pre .. (@$in-1)) {
    print "$in->[$i]  @{$in}[$i-$pre .. $i-1]\n" if DEBUG;
    my $iter = combinations([@{$in}[$i-$pre .. $i-1]], 2);
    my $valid = undef;
    while (my $c = $iter->next) {
      if ((sum @$c) == $in->[$i]) {
        $valid = 1;
      }
    }
    return $in->[$i] unless ( $valid );
  }
  return 0;
}

sub calc2 {
  my ($in, $part1) = @_;
  for my $n (1 .. @{$in}-1) {
    for my $j (0..@{$in}-$n-1) {
      print "$n $j ", ($j+$n), " @{$in}[$j..$j+$n]\n" if DEBUG;
      if ((sum @{$in}[$j..$j+$n]) == $part1) {
        return (min @{$in}[$j..$j+$n]) + (max @{$in}[$j..$j+$n]);
      }
    }
  }
  return 0;
}

testPart1() if (TEST);

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2, $part1), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 5, 127 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]), $tc->[1]);
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[2]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 127, 62 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]), $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[2]);
  }
}
