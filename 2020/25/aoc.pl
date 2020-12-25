#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

use Inline qw/C/;

sub loopsize {
  my ($t) = @_;
  my $p = 1;
  my $s = 7;
  my $l = 0;
  while ($p != $t) {
    $p *= $s;
    $p %= 20201227;
    $l++;
  }
  return $l;
}

sub expmod {
  my($a, $b, $n) = @_;
  $n = 20201227;
  my $c = 1;
  do {
    ($c *= $a) %= $n if $b % 2;
    ($a *= $a) %= $n;
  } while ($b = int $b/2);
  $c;
}


sub calc {
  my ($in) = @_;
  my $ls = loopsizeC($in->[0]);
  return expmod($in->[1], $ls);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

sub testPart1 {
  assertEq("card loop size", loopsize(5764801), 8);
  assertEq("door loop size", loopsize(17807724), 11);
  assertEq("door with card", expmod(17807724, 8), 14897079);
  assertEq("card with door", expmod(5764801, 11), 14897079);
  my @test_cases =
    (
     [ "test1.txt", 14897079 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}
__END__
__C__
  int loopsizeC(int t) {
    int p = 1;
    int s = 7;
    int l = 0;
    while (p != t) {
      p *= s;
      p %= 20201227;
      l++;
    }
    return l;
  }
