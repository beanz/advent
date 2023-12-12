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
  my ($s, @b) = @_;
  return aux([split//,$s], [@b], 0, 0, 0);
}

no warnings 'recursion';
sub aux {
  my ($s, $n, $si, $ni, $l) = @_;
  #print "@$s $si @$n $ni  $l\n";
  state %mem;
  my $k = "@$s $si @$n $ni $l";
  return $mem{$k} if (exists $mem{$k});
  if (@$s == $si) {
    #print "end of string\n";
    if (@$n == $ni && $l == 0) {
      return 1;
    }
    if ($ni == @$n-1 && $n->[$ni] == $l) {
      return 1;
    }
    return 0;
  }
  my $r = 0;
  if ($s->[$si] eq '.' || $s->[$si] eq '?') {
    if ($l == 0) {
      #print ".|? no current\n";
      $r += aux($s, $n, $si+1, $ni, 0);
    } elsif ($l > 0 && $ni < @$n && $n->[$ni] == $l) {
      #print ".|? current block complete\n";
      $r += aux($s, $n, $si+1, $ni+1, 0);
    }
  }
  if ($s->[$si] eq '#' || $s->[$si] eq '?') {
    $r += aux($s, $n, $si+1, $ni, $l+1);
  }
  $mem{$k} = $r;
  return $r;
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
    for (0..4) {
       push @n, @l; 
     }
    $p2 += solve($s, @n);
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
