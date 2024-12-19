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

my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my $re = [split /, /, shift @$in];
  shift @$in;
  return [$re, $in, $file];
}

sub matches {
  my ($re, $s, $m) = @_;
  return $m->{$s} if (exists $m->{$s});
  my $c = 0;
  if ($s eq '') {
    return $m->{$s} = 1;
  }
  for my $tp (@$re) {
    my $t = $s;
    my $pre = substr $t, 0, length($tp), '';
    if ($pre eq $tp) {
      $c += matches($re, $t, $m);
    }
  }
  $m->{$s} = $c;
  return $c;
}

sub calc {
  my ($in) = @_;
  my ($patterns, $lines) = @$in;
  my $re = '^(?:' . (join '|', @$patterns) . ')*$';
  my $p1 = 0;
  for my $l (@$lines) {
    $p1++ if ($l =~ /$re/);
  }
  my $p2 = 0;
  my $mem = {};
  for my $l (@$lines) {
    $p2 += matches($patterns, $l, $mem);
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
