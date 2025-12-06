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

my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my @ops = split /\s+/, pop @$in;
  my @nums;
  for my $l (@$in) {
    my $c = $l;
    $c =~ s/^\s+//;
    my @n = split /\s+/, $c;
    push @nums, \@n;
  }
  my $p1 = 0;
  for my $i (0 .. $#ops) {
    my $op = $ops[$i];
    my $s;
    if ($op eq '+') {
      $s = sum(map {$_->[$i]} @nums);
    } else {
      $s = product(map {$_->[$i]} @nums);
    }
    $p1 += $s;
  }
  my $p2 = 0;
  my $l = length($in->[0]);
  my @lines = map {[split //]} @$in;
  my @s;
  for my $i (0 .. $l - 1) {
    my @d;
    for my $l (@lines) {
      push @d, $l->[$i] // "";
    }
    my $n = join "", @d;
    if ($n =~ s/^\s+$//) {
      $p2 += apply(\@s, shift @ops);
      @s = ();
    } else {
      $n =~ s/\s+//;
      push @s, $n;
    }
  }
  $p2 += apply(\@s, shift @ops);

  return [$p1, $p2];
}

sub apply {
  my ($n, $op) = @_;
  if ($op eq '+') {
    return sum(@$n);
  }
  return product(@$n);
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
