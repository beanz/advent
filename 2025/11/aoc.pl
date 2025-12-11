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
  my %m;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my ($s, @r) = split /:?\s+/, $l;
    $m{$s} = \@r;
  }
  return \%m;
}

sub search {
  my ($g, $c) = @_;
  if ($c eq 'out') {
    return 1;
  }
  my $res = 0;
  for my $n (@{$g->{$c}}) {
    $res += search($g, $n);
  }
  return $res;
}

sub search2 {
  my ($g, $c, $v, $s) = @_;
  return $s->{"$c,$v"} if (exists $s->{"$c,$v"});
  if ($c eq 'out') {
    return $s->{"$c,$v"} = $v == 3 ? 1 : 0;
  }
  if ($c eq 'dac') {
    $v |= 2;
  }
  if ($c eq 'fft') {
    $v |= 1;
  }
  my $res = 0;
  for my $n (@{$g->{$c}}) {
    $res += search2($g, $n, $v, $s);
  }
  return $s->{"$c,$v"} = $res;
}

sub calc {
  my ($in) = @_;
  my $p1 = search($in, 'you');
  my $p2 = search2($in, 'svr', 0, {});
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
