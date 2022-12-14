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
  my ($in) = @_;
  my $m = $in->{m};
  my @bb2 = @{$in->{bb}};
  my ($c, $p1, $p2) = (0, 0, 0);
  my ($x, $y) = (500, 0);
  while (1) {

    #print "S: $x,$y\n";
    if (!$p1 && ($x > $in->{bb}->[MAXX] || $x < $in->{bb}->[MINX])) {
      $p1 = $c;
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
      $p2 = $c + 1;
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
  return [$p1, $p2];
}

testParts() if (TEST);

my $res = calc($i);
print "Part 1: ", $res->[0], "\n";
print "Part 2: ", $res->[1], "\n";

sub testParts {
  my @test_cases = (["test1.txt", 24, 93], ["input.txt", 1513, 22646],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
