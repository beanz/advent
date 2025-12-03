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
  return [map {[split //]} @$in];
}

sub pp {
  my ($l, $o, $i) = @_;
  my $s = "";
  for ($o .. @$l - 1 - $i) {
    $s .= $l->[$_];
  }
  return $s;
}

sub best {
  my ($l, $o, $i) = @_;
  my $m = $l->[$o];
  my $mi = $o;
  for ($o + 1 .. @$l - 1 - $i) {
    if ($l->[$_] > $m) {
      ($m, $mi) = ($l->[$_], $_);
    }
  }
  return [$m, $mi + 1];
}

sub search {
  my ($in, $n) = @_;
  my $res = 0;
  for my $l (@$in) {
    my $r = "";
    my $mi = 0;
    my $m;
    for my $rem (reverse 0 .. $n - 1) {
      ($m, $mi) = @{best($l, $mi, $rem)};
      $r .= $m;
    }
    $res += $r;
  }
  return $res;
}

sub calc {
  my ($in) = @_;
  my $p1 = search($in, 2);
  my $p2 = search($in, 12);
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
