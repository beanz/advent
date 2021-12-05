#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_chunks($file);
my $i2 = read_chunks($file);

sub calc {
  my ($i, $part) = @_;
  my $s = 0;
  for my $c (@$i) {
    $c =~ s/\n//g;
    my %m = map { $_ => 1 } split//, $c;
    $s+=~~keys %m;
  }
  return $s;
}

sub calc2 {
  my ($i, $part) = @_;
  my $s = 0;
  for (@$i) {
    chomp;
    my $c = s/\n//g + 1;
    my %m;
    $m{$_}++ for (split//);
    my @y = grep $m{$_} == $c, keys %m;
    $s+=@y;
  }
  return $s;
}

testPart1() if (TEST);

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 11 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_chunks($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 6 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_chunks($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
