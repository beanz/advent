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
  my @b;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my @n = split /\D/, $l;
    push @b, [0 + $n[0], 0 + $n[1], 0 + $n[2], 1 + $n[3], 1 + $n[4], 1 + $n[5]];
  }
    @b = sort {$a->[Z] <=> $b->[Z]} @b;
  return \@b;
}

sub intersected {
  my ($a, $b) = @_;
  return 0 if ($b->[0] >= $a->[3] or $a->[0] >= $b->[3]);
  return 0 if ($b->[1] >= $a->[4] or $a->[1] >= $b->[4]);
  return 0 if ($b->[2] >= $a->[5] or $a->[2] >= $b->[5]);
  return 1;
}

sub all_intersects {
  my ($in, $i, $t) = @_;
  my @r;
  for my $j (0 .. @$in - 1) {
    next if ($i == $j);
    if (intersected($t, $in->[$j])) {
      push @r, $j;
    }
  }
  return \@r;
}

sub calc {
  my ($in) = @_;
  my @s;
  push @s, [] for (@$in);
  my @sc = ();
  for my $i (0 .. @$in - 1) {
    my $r = [];
    while ($in->[$i]->[Z] > 1) {
      my $t = [@{$in->[$i]}];
      $t->[Z]--;
      $t->[Z + 3]--;
      $r = all_intersects($in, $i, $t);
      last if (@$r);
      $in->[$i] = $t;
    }
    push @{$s[$_]}, $i for (@$r);
    $sc[$i] = @$r;
  }
  my $p1 = 0;
  my $p2 = 0;
  for my $i (0..@$in-1) {
    my $dis = 0;
    my @rem;
    my @todo = @{$s[$i]};
    while (defined(my $cur = shift @todo)) {
      $rem[$cur]++;
      if ($sc[$cur] == $rem[$cur]) {
        push @todo, @{$s[$cur]//[]};
        $dis++;
      }
    }
    $p1++ unless ($dis);
    $p2+= $dis;
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
