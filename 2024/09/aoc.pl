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

my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

use constant {
  SIZE => 0,
  ID => 1,
  IDX => 2,
};

sub defrag {
  my @n = @{$_[0]};
  my $s = 0;
  for my $i (reverse 0 .. $#n) {
    next unless (defined $n[$i][ID]);
    next unless ($n[$i][SIZE] > 0);
    for my $j (0 .. $i-1) {
      next if (defined $n[$j][ID]);
      next unless ($n[$i][SIZE] <= $n[$j][SIZE]);
      $n[$i][IDX] = $n[$j][IDX];
      $n[$j][IDX] += $n[$i][SIZE];
      $n[$j][SIZE] -= $n[$i][SIZE];
      last;
    }
    my $b = $n[$i];
    for my $o (0 .. $b->[SIZE] - 1) {
      $s += ($b->[IDX] + $o) * $b->[ID];
    }
  }
  return $s;
}

sub pb {
  my ($b) = @_;
  return
      $b->[IDX] . ":"
    . ($b->[SIZE] != 1 ? $b->[SIZE] . "x" : '')
    . ($b->[ID] // '.');
}

sub dp {
  my @n = @{$_[0]};
  @n = sort {$a->[IDX] <=> $b->[IDX]} @n;
  print STDERR join(', ', map {pb($_)} @n), "\n";
}

sub pp {
  my @n = @{$_[0]};
  @n = sort {$a->[IDX] <=> $b->[IDX]} @n;
  my $s;
  my $i;
  for my $b (@n) {
    for (1 .. $b->[SIZE]) {
      $s .= $b->[ID] // ".";
      if ($_ == 1) {
        $i .= bold($b->[IDX]);
      } else {
        $i .= $b->[IDX] - 1 + $_;
      }
    }
  }
  print STDERR "$s\n$i\n";
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $id = 0;
  my @l = split//,$in;
  my @n;
  my @n1;
  my @n2;
  my $i = 0;

  while (~~ @l) {
    my $b = shift @l;
    if ($b != 0) {
      push @n, [$b, $id, $i];
      push @n1, [1, $id, $i + $_] for (0 .. $b - 1);
      push @n2, [$b, $id, $i];
    }
    $i += $b;
    $id++;
    my $f = shift @l;
    last unless (defined $f);
    if ($f != 0) {
      push @n, [$f, undef, $i];
      push @n1, [1, undef, $i + $_] for (0 .. $f - 1);
      push @n2, [$f, undef, $i];
    }
    $i += $f;
  }
  my $j = 0;
  while (~~ @n) {
    my $v = $n[0][1];
    unless (defined $v) {
      unless (defined $n[$#n][1]) {
        pop @n;
        next;
      }
      $v = $n[$#n][1];
      $n[$#n][0]--;
      if ($n[$#n][0] == 0) {
        pop @n;
      }
    }
    $p1 += $j * $v;
    $n[0][0]--;
    if ($n[0][0] == 0) {
      shift @n;
    }
    $j++;
  }
  my $p2 = defrag(\@n2);
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
