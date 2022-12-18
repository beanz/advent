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

#my $reader = \&read_stuff;
my $reader = \&read_guess;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m = (lines => $in);
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    print "$i: $l\n";
  }
  return \%m;
}

sub calc {
  my ($in) = @_;
  my $p1 = 6 * @$in;
  my ($mx, $my, $mz) = (1000000, 1000000, 1000000);
  my ($mX, $mY, $mZ) = (0, 0, 0);
  my %t = ();
  for my $i (0 .. @$in - 1) {
    my ($x, $y, $z) = @{$in->[$i]};
    $mx = $x if ($x < $mx);
    $my = $y if ($y < $my);
    $mz = $z if ($z < $mz);
    $mX = $x if ($x > $mX);
    $mY = $y if ($y > $mY);
    $mZ = $z if ($z > $mZ);
    $t{$x, $y, $z}++;

    # print "$x, $y, $z\n";
    for my $j ($i + 1 .. @$in - 1) {
      my ($X, $Y, $Z) = @{$in->[$j]};

      #print "$X, $Y, $Z\n";
      if ($x == $X && $y == $Y && ($z == $Z - 1 || $z == $Z + 1)) {
        $p1 -= 2;
      }
      if ($y == $Y && $z == $Z && ($x == $X - 1 || $x == $X + 1)) {
        $p1 -= 2;
      }
      if ($z == $Z && $x == $X && ($y == $Y - 1 || $y == $Y + 1)) {
        $p1 -= 2;
      }
    }
  }
  my $p2 = 0;
  $mX++;
  $mY++;
  $mZ++;
  $mx--;
  $my--;
  $mz--;
  my @todo = ([$mX, $mY, $mZ]);
  my %v;

  while (@todo) {
    my ($x, $y, $z) = @{shift @todo};
    next if ($t{$x, $y, $z} || $v{$x, $y, $z});
    $v{$x, $y, $z}++;
    if ($t{$x + 1, $y, $z}) {
      $p2++;
    } else {
      push @todo, [$x + 1, $y, $z] if ($x < $mX);
    }
    if ($t{$x - 1, $y, $z}) {
      $p2++;
    } else {
      push @todo, [$x - 1, $y, $z] if ($x > $mx);
    }
    if ($t{$x, $y + 1, $z}) {
      $p2++;
    } else {
      push @todo, [$x, $y + 1, $z] if ($y < $mY);
    }
    if ($t{$x, $y - 1, $z}) {
      $p2++;
    } else {
      push @todo, [$x, $y - 1, $z] if ($y > $my);
    }
    if ($t{$x, $y, $z + 1}) {
      $p2++;
    } else {
      push @todo, [$x, $y, $z + 1] if ($z < $mZ);
    }
    if ($t{$x, $y, $z - 1}) {
      $p2++;
    } else {
      push @todo, [$x, $y, $z - 1] if ($z > $mz);
    }
  }
  return [$p1, $p2];
}

testParts() if (TEST);

my $res = calc($i);
print "Part 1: ", $res->[0], "\n";
print "Part 2: ", $res->[1], "\n";

sub testParts {
  my @test_cases = (["test1.txt", 64, 58], ["input.txt", 3498, 2008],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 1 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
