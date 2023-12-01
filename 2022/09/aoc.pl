#!/usr/bin/env perl
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

sub move {
  my ($h, $t) = @_;
  my $dx = $h->[X] - $t->[X];
  my $dy = $h->[Y] - $t->[Y];
  if (abs($dx) <= 1 && abs($dy) <= 1) {

    # touching
  } elsif (abs($dx) > 1 && abs($dy) > 1) {
    $t->[X] = $dx > 0 ? $h->[X] - 1 : $h->[X] + 1;
    $t->[Y] = $dy > 0 ? $h->[Y] - 1 : $h->[Y] + 1;
  } elsif (abs($dx) > 1) {
    $t->[X] = $dx > 0 ? $h->[X] - 1 : $h->[X] + 1;
    $t->[Y] = $h->[Y];
  } elsif (abs($dy) > 1) {
    $t->[X] = $h->[X];
    $t->[Y] = $dy > 0 ? $h->[Y] - 1 : $h->[Y] + 1;
  }
  return $t;
}

sub calc {
  my ($in) = @_;
  my %v1;
  my %v2;
  my $h = [0, 0];
  my @t;
  for (0 .. 8) {push @t, [0, 0];}
  my %o = ("R" => [1, 0], "L" => [-1, 0], "U" => [0, -1], "D" => [0, 1]);
  for (@$in) {
    my ($dir, $n) = @$_;
    my $o = $o{$dir};

    #print "$dir @$o x $n\n";
    for my $step (1 .. $n) {
      $h->[X] += $o->[X];
      $h->[Y] += $o->[Y];
      $t[0] = move($h, $t[0]);
      for (1 .. 8) {
        $t[$_] = move($t[$_ - 1], $t[$_]);
      }
      $v1{"@{$t[0]}"}++;
      $v2{"@{$t[8]}"}++;

      #print "HT: @$h   @$t\n";
      #pp($h,$t);
      #sleep 1;
    }
  }
  return [scalar keys %v1, scalar keys %v2];
}

sub pp {
  my ($h, $t) = @_;
  for my $y (-5, -4, -3, -2, -1, 0) {
    for my $x (0 .. 5) {
      if ($x == 0 && $y == 0) {
        print "s";
      } elsif ($x == $h->[X] && $y == $h->[Y]) {
        print "H";
      } elsif ($x == $t->[X] && $y == $t->[Y]) {
        print "T";
      } else {
        print ".";
      }
    }
    print "\n";
  }
}

testParts() if (TEST);

my $res = calc($i);
print "Part 1: ", $res->[0], "\n";
print "Part 2: ", $res->[1], "\n";

sub testParts {
  my @test_cases =
    (["test1.txt", 13, 1], ["test2.txt", 88, 36], ["input.txt", 5513, 2427],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
