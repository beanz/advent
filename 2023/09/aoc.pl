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

sub solve {
  my ($in) = @_;
  my $l = @$in;
  my @d;
  my %c;
  for my $i (0 .. $l - 2) {
    my $d = ($in->[$i + 1]) - ($in->[$i]);
    push @d, $d;
    $c{$d}++;
  }
  if ((keys %c) == 1) {
    return $in->[$l - 1] + $d[0];
  }
  return $in->[$l - 1] + solve(\@d);
}

sub calc {
  my ($in) = @_;
  my @r;
  for (@$in) {
    $r[0] += solve($_);
    $r[1] += solve([reverse @$_]);
  }
  return \@r;
}

testParts() if (TEST);

my $r = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$r;

sub testParts {
  my @test_cases = (["test1.txt", 114, 2], ["input.txt", 1584748274, 1026],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
