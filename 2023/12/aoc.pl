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
  return [map {[split /\s|,/, $_]} @$in];
}

#print solve('.', qw/1/), "\n";
#print solve('#', qw/1/), "\n";
#print solve('?', qw/1/), "\n";
#print solve('???.###', qw/1 1 3/), "\n";

sub solve {
  my ($str, @b) = @_;
  my @s = ('.');
  for (@b) {
    push @s, ('#') x $_;
    push @s, '.';
  }
  my $sc = {0 => 1};
  my $nsc = {};
  for my $ch (split//, $str) {
    for my $s (keys %$sc) {
      if ($ch eq '#') {
        if ($s+1 < @s && $s[$s+1] eq '#') {
          $nsc->{$s+1} += $sc->{$s};
        }
      } elsif ($ch eq '.') {
        if ($s+1 < @s && $s[$s+1] eq '.') {
          $nsc->{$s+1} += $sc->{$s};
        }
        if ($s[$s] eq '.') {
          $nsc->{$s} += $sc->{$s};
        }
      } else { # ?
        if ($s+1 < @s) {
          $nsc->{$s+1} += $sc->{$s};
        }
        if ($s[$s] eq '.') {
          $nsc->{$s} += $sc->{$s};
        }
      }
    }
    $sc = $nsc;
    $nsc ={};
    #dd([$sc],[qw/sc/]);
  }
  return ($sc->{@s-1}//0) + ($sc->{@s-2}//0);
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  for my $l (@$in) {
    my @l = @$l;
    my $s = shift @l;
    $p1 += solve($s, @l);
  }
  my $p2 = 0;
  for my $l (@$in) {
    my @l = @$l;
    my $s = shift @l;
    $s = join '?', $s, $s, $s, $s, $s;
    my @n;
    for (0 .. 4) {
      push @n, @l;
    }
    $p2 += solve($s, @n);
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
