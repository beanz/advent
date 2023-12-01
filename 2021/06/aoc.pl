#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_school;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_school {
  my $file = shift;
  my $in = read_lines($file);
  return [ split/,/, $in->[0] ];
}

sub calc {
  my ($init, $days) = @_;
  my @s = (0) x 9;
  for my $t (@$init) {
    $s[$t]++;
  }
  for my $day (1..$days) {
    my @n = (0) x 9;
    $n[6] = $n[8] = $s[0];
    for my $d (0 .. 7) {
      $n[$d] += $s[$d+1];
    }
    @s = @n;
  }
  return sum(@s);
}

testCalc() if (TEST);

print "Part 1: ", calc($i, 80), "\n";
print "Part 2: ", calc($i2, 256), "\n";

sub testCalc {
  my @test_cases =
    (
     [ "test1.txt", 1, 5 ],
     [ "test1.txt", 2, 6 ],
     [ "test1.txt", 3, 7 ],
     [ "test1.txt", 9, 11 ],
     [ "test1.txt", 18, 26 ],
     [ "test1.txt", 80, 5934 ],
     [ "test1.txt", 256, 26984457539 ],
     [ "input.txt", 80, 365131 ],
     [ "input.txt", 256, 1650309278600 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 1 [$tc->[0] $tc->[1]]", $res, $tc->[2]);
  }
}
