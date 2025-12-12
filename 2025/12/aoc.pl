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

sub read_stuff {
  my $file = shift;
  my $in = read_chunks($file);
  my %m;
  my $p = pop @$in;

  for my $l (split /\n/, $p) {
    if ($l =~ /^(\d+)x(\d+):\s+(.+)$/) {
      my ($w, $h, $r) = ($1, $2, $3);
      my @r = split / /, $r;
      push @{$m{l}}, {w => $w, h => $h, n => \@r};
    }
  }
  $m{s} = [map {~~ y/#//} @$in];
  return \%m;
}

sub calc {
  my ($m) = @_;
  my $p1 = 0;
  for my $l (@{$m->{l}}) {
    my $a = $l->{w} * $l->{h};
    my $b = sum(map {$m->{s}->[$_] * $l->{n}->[$_]} 0 .. 5);
    $p1++ unless ($a < $b);
  }
  my $p2 = 0;
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
