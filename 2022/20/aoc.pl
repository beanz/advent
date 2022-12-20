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
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @m;
  for my $i (0 .. @$in - 1) {
    push @m, [$i, $in->[$i]];
  }
  return \@m;
}

use constant {
  IDX => 0,
  NUM => 1,
};

sub by_idx {
  my ($m, $i) = @_;
  for (0 .. @$m - 1) {
    if ($m->[$_]->[IDX] == $i) {
      return @{$m->[$_]};
    }
  }
}

sub by_num {
  my ($m, $i) = @_;
  for (0 .. @$m - 1) {
    if ($m->[$_]->[NUM] == $i) {
      return $_;
    }
  }
}

sub pp {
  my ($m, $mul) = @_;
  $mul //= 1;
  print join(", ", map {$_->[NUM] * $mul} @$m), "\n";
}

sub mix {
  my ($m, $i, $mul) = @_;
  $mul //= 1;
  my ($j, $n) = by_idx($m, $i);
  $n *= $mul;
  while ($m->[0]->[IDX] != $i) {
    push @{$m}, shift @{$m};
  }
  my $it = shift @{$m};
  for (0 .. ($n % @$m) - 1) {
    push @{$m}, shift @{$m};
  }
  push @$m, $it;
}

sub calc {
  my ($in) = @_;
  for (0 .. @$in - 1) {
    mix($in, $_);
  }
  my $i = by_num($in, 0);
  return $in->[($i + 1000) % @$in]->[1] + $in->[($i + 2000) % @$in]->[1] +
    $in->[($i + 3000) % @$in]->[1];
}

sub calc2 {
  my ($in) = @_;
  my $big = 811589153;
  for my $r (0 .. 9) {
    print "Round $r\n" if DEBUG;
    for (0 .. @$in - 1) {
      mix($in, $_, $big);
    }
  }
  my $i = by_num($in, 0);
  if (DEBUG) {
    print $big*$in->[($i + 1000) % @$in]->[NUM], "\n";
    print $big*$in->[($i + 2000) % @$in]->[NUM], "\n";
    print $big*$in->[($i + 3000) % @$in]->[NUM], "\n";
  }
  return $big * $in->[($i + 1000) % @$in]->[1] +
    $big * $in->[($i + 2000) % @$in]->[1] +
    $big * $in->[($i + 3000) % @$in]->[1];
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 3], ["input.txt", 17490],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test1.txt", 1623178306], ["input.txt", 1632917375836],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
