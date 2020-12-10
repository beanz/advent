#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);
#print dd([$i]); exit;
my $i2 = read_lines($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

sub calc {
  my ($in, $pre) = @_;
  my $max = 3 + max(@$in);
  $in = [sort { $a <=> $b } @$in, $max];
  my $cj = 0;
  my %d;
  for my $j (@$in) {
    my $d = $j-$cj;
    $d{$d}++;
    $cj = $j;
  }
  return $d{1} * $d{3};
}

sub arrange {
  my ($cj, $tj, $in) = @_;
  state %s;
  my $k = $cj."!".@$in;
  return $s{$k} if (exists $s{$k});
  unless (@$in) { return $s{$k} = 1; }
  print "($cj), ", join(', ', @{$in||[]}), " ($tj)\n" if DEBUG;
  my @j = splice @$in, 0, 3, ();
  my $c = 0;
  while (defined(my $j = shift @j)) {
    if ($j - $cj <= 3) {
      $c += arrange($j, $tj, [@j, @$in]);
    }
  }
  return $s{$k} = $c;
}

sub calc2 {
  my ($in) = @_;
  return arrange(0, $in->[@$in-1]+3, [sort { $a <=> $b } @$in]);
}

testPart1() if (TEST);

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2, $part1), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 7*5 ],
     [ "test2.txt", 220 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 8 ],
     [ "test2.txt", 19208 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
