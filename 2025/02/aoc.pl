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
  return [map {[split /-/, $_]} split /,/, $in->[0]];
}

sub invalid {
  my ($id) = @_;
  return ($id =~ /^(.*)\1$/);
}

sub invalid2 {
  my ($id) = @_;
  return ($id =~ /^(.*)(\1)+$/);
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  for my $l (@$in) {
    my ($s, $e) = @$l;
    for ($s .. $e) {
      $p1 += $_ if (invalid($_));
      $p2 += $_ if (invalid2($_));
    }
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
