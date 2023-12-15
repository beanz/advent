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
  return [split /,/, $in->[0]];
}

sub hash {
  my ($s) = @_;
  my $cv = 0;
  for my $ch (split //, $s) {
    $cv += ord($ch);
    $cv *= 17;
    $cv %= 256;
  }
  $cv;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my %b = ();
  for my $l (@$in) {
    $p1 += hash($l);
    $l =~ /^(.*)(-|=(\d+))$/ or die "$l\n";
    my ($s, $op, $v) = ($1, $2, $3);
    my $bn = hash($s);
    if ($op eq '-') {
      for my $i (0 .. @{$b{$bn} || []} - 1) {
        if ($b{$bn}->[$i]->[0] eq $s) {
          my $o = splice @{$b{$bn}}, $i, 1;
          last;
        }
      }
    } else {
      my $found;
      for my $i (0 .. @{$b{$bn} || []} - 1) {
        if ($b{$bn}->[$i]->[0] eq $s) {
          $b{$bn}->[$i]->[1] = $v;
          $found = 1;
          last;
        }
      }
      push @{$b{$bn}}, [$s, $v] unless ($found);
    }
  }
  my $p2 = 0;
  for my $bn (sort {$a <=> $b} keys %b) {
    for my $sn (0 .. @{$b{$bn}} - 1) {
      $p2 += ($bn + 1) * ($sn + 1) * $b{$bn}->[$sn]->[1];
    }
  }

  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
