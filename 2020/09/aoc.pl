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
  my @sums = ();
  for my $i (0 .. $pre-2) {
    for my $j ($i+1 .. $pre-1) {
      push @{$sums[$i]}, $in->[$i] + $in->[$j];
    }
  }
  for my $i ($pre .. (@$in-1)) {
    print "$in->[$i]  @{$in}[$i-$pre .. $i-1]\n" if DEBUG;
    my $valid = undef;
    for my $s (@sums) {
      for my $t (@$s) {
        if ($t == $in->[$i]) {
          $valid = 1;
          last;
        }
      }
    }
    return $in->[$i] unless ( $valid );
    shift @sums;
    for my $j (0..@sums-1) {
      push @{$sums[$j]}, $in->[$i-$pre+$j+1]+$in->[$i];
    }
    push @sums, [$in->[$i-1] + $in->[$i]];
  }
  return 0;
}

sub calc2 {
  my ($in, $part1) = @_;
  my $start = 0;
  my $end = 2;
  my $sum = sum @{$in}[$start..$end];
  while ($sum != $part1 || $start == ($end - 1)) {
    if ($sum < $part1) {
      $end++;
      $sum += $in->[$end];
    } else {
      $sum -= $in->[$start];
      $start++;
    }
  }
  return (min @{$in}[$start..$end]) + (max @{$in}[$start..$end])
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
