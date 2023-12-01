#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);

my $i2 = read_lines($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

sub pp {
  my ($p) = @_;
  return sprintf "%s %d, %s %d",
    ($p->[X] >= 0 ? "east" : "west"), abs($p->[X]),
    ($p->[Y] <= 0 ? "north" : "south"), abs($p->[Y]);
}

sub pd {
  my ($dir) = @_;
  return '['.(join',',@$dir).']'
}

sub calc {
  my ($in) = @_;
  my $c = 0;
  my $p = [0,0];
  my $dir = compassOffset('E');
  print pp($p), " ", pd($dir), "\n" if (DEBUG);
  for my $l (@$in) {
    my ($a, $n) = split//, $l, 2;
    if ($a =~ /^(?:N|S|E|W)$/) {
      my $o = compassOffset($a);
      for (0..$n-1) {
        $p->[X] += $o->[X];
        $p->[Y] += $o->[Y];
      }
    } elsif ($a eq 'L') {
      my $t = $n / 90;
      for (1..$t) {
        $dir = offsetCCW(@$dir);
      }
    } elsif ($a eq 'R') {
      my $t = $n / 90;
      for (1..$t) {
        $dir = offsetCW(@$dir);
      }
    } elsif ($a eq 'F') {
      for (0..$n-1) {
        $p->[X] += $dir->[X];
        $p->[Y] += $dir->[Y];
      }
    } else {
      die "$l\n";
    }
    print pp($p), " ", pd($dir), ": $a $n\n" if (DEBUG);
  }
  return manhattanDistance($p, [0,0]);
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  my $p = [0,0];
  my $wp = [10, -1];
  print pp($p), " ", pp($wp), "\n" if (DEBUG);
  for my $l (@$in) {
    my ($a, $n) = split//, $l, 2;
    if ($a =~ /^(?:N|S|E|W)$/) {
      my $o = compassOffset($a);
      for (0..$n-1) {
        $wp->[X] += $o->[X];
        $wp->[Y] += $o->[Y];
      }
    } elsif ($a eq 'L') {
      my $t = $n / 90;
      for (1..$t) {
        my $t = $wp->[X];
        $wp->[X] = $wp->[Y];
        $wp->[Y] = -1 * $t;
      }
    } elsif ($a eq 'R') {
      my $t = $n / 90;
      for (1..$t) {
        my $t = $wp->[X];
        $wp->[X] = -1 * $wp->[Y];
        $wp->[Y] = $t;
      }
    } elsif ($a eq 'F') {
      for (0..$n-1) {
        $p->[X] += $wp->[X];
        $p->[Y] += $wp->[Y];
      }
    } else {
      die "$l\n";
    }
    print pp($p), " ", pp($wp), ": $a $n\n" if (DEBUG);
  }
  return manhattanDistance($p, [0,0]);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 25 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 286 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
