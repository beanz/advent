#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my @n = split / /, $i[0];
print 'Part 1: ', parse([@n]), "\n";
print 'Part 2: ', parse2(\@n), "\n";

sub parse {
  my $e = shift;
  my $s = 0;
  my $c = shift @$e;
  my $m = shift @$e;
  for (1..$c) {
    $s += parse($e);
  }
  for (1..$m) {
    $s += shift @$e;
  }
  return $s;
}

sub parse2 {
  my $e = shift;
  my $s = 0;
  my $c = shift @$e;
  my $m = shift @$e;
  if ($c) {
    my @c;
    for (1..$c) {
      push @c, parse2($e);
    }
    for (1..$m) {
      my $me = shift @$e;
      $s += $c[$me-1] if ($me <= @c);
    }
  } else {
    for (1..$m) {
      $s += shift @$e;
    }
  }
  return $s;
}


