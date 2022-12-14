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
  my $in = read_guess($file);
  my %m = (m => {}, bb => [undef, undef, undef, undef]);
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my ($x, $y) = @{shift @$l};

    #print "S: $x, $y\n";
    $m{m}->{$x, $y} = '#';
    minmax_xy($m{bb}, $x, $y);
    while (@$l) {
      my ($nx, $ny) = @{shift @$l};
      while ($x != $nx || $y != $ny) {
        if ($x < $nx) {
          $x++;
        } elsif ($x > $nx) {
          $x--;
        }
        if ($y < $ny) {
          $y++;
        } elsif ($y > $ny) {
          $y--;
        }
        $m{m}->{$x, $y} = '#';
        minmax_xy($m{bb}, $x, $y);
      }
    }
  }
  return \%m;
}

sub pp {
  my ($m) = @_;
  for my $y ($m->{bb}->[MINY] .. $m->{bb}->[MAXY]) {
    for my $x ($m->{bb}->[MINX] .. $m->{bb}->[MAXX]) {
      print $m->{m}->{$x, $y} // '.';
    }
    print "\n";
  }
}

sub calc {
  my ($in, $p2) = @_;
  my $m = $in->{m};
  my @bb2 = @{$in->{bb}};
  my $c = 0;
  my ($x, $y) = (500, 0);
  while (1) {

    #print "S: $x,$y\n";
    if (!$p2 && ($x > $in->{bb}->[MAXX] || $x < $in->{bb}->[MINX])) {
      last;
    }
    if ($y < $in->{bb}->[MAXY] + 1) {
      if (!exists $m->{$x, $y + 1}) {
        $y++;
        next;
      }
      if (!exists $m->{$x - 1, $y + 1}) {
        $y++;
        $x--;
        next;
      }
      if (!exists $m->{$x + 1, $y + 1}) {
        $y++;
        $x++;
        next;
      }
    }
    if ($x == 500 && $y == 0) {
      $c++;
      last;
    }
    minmax_xy(\@bb2, $x, $y);
    $m->{$x, $y} = 'o';
    $c++;
    $x = 500;
    $y = 0;

    #pp($in);
    #select undef,undef,undef, 0.5;
  }
  if (DEBUG) {
    print scalar keys %$m, "\n";
    dd([\@bb2], [qw/bb2/]);
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc($i2, 1), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 24], ["input.txt", 1513],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (
    ["test1.txt", 93],
    ["input.txt", 22646],
  );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]), 1);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
