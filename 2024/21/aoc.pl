#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

use Carp::Always qw/carp verbose/;

#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

use constant {
  CH => 2,
  DX => [0, 1, 0, -1],
  DY => [-1, 0, 1, 0],
  DCH => ['^', '>', 'v', '<'],
};

my $dirpad = DenseMap->from_lines(['#####', '##^A#', '#<v>#', '#####']);
my $numpad =
  DenseMap->from_lines(['#####', '#789#', '#456#', '#123#', '##0A#', '#####',]);

sub solve {
  my ($p) = @_;
  my %m;
  my @s;
  for my $y (0 .. $p->height - 1) {
    for my $x (0 .. $p->width - 1) {
      my $ch = $p->get($x, $y);
      if ($ch ne '#') {
        push @s, [$x, $y, $ch];
      }
    }
  }
  my %r;
  for my $i (0 .. $#s) {
    my ($sx, $sy, $sch) = @{$s[$i]};
    for my $j (0 .. $#s) {
      my ($tx, $ty, $tch) = @{$s[$j]};
      if ($i == $j) {
        $r{$sch . $tch} = [''];
        next;
      }
      my @sr;
      my @todo = [$sx, $sy, ''];
      my %seen;
      while (@todo) {
        my ($cx, $cy, $path) = @{shift @todo};
        next if (exists $seen{$cx, $cy} && $seen{$cx, $cy} < length($path));
        $seen{$cx, $cy} = length $path;
        if ($p->get($cx, $cy) eq $tch) {
          push @sr, $path;
          next;
        }
        for my $d (0 .. 3) {
          my ($nx, $ny, $nch) = ($cx + DX->[$d], $cy + DY->[$d], DCH->[$d]);
          if ($p->get($nx, $ny) ne '#') {
            push @todo, [$nx, $ny, $path . $nch];
          }
        }
      }
      $r{$sch . $tch} = \@sr;
    }
  }
  return \%r;
}
my $dp = solve($dirpad);
my $np = solve($numpad);

sub keypath {
  my ($from, $to, $pad) = @_;
  [map {$_ . 'A'} @{$pad->{$from . $to}}];
}

sub len {
  my ($s, $d, $max) = @_;
  state %s;
  return $s{$s, $d, $max} if (exists $s{$s, $d, $max});
  my $pad = $d == 0 ? $np : $dp;
  my $l = 0;
  my $cur = 'A';
  for my $key (split //, $s) {
    my $p = keypath($cur, $key, $pad);
    if ($d == $max) {
      $l += length $p->[0];
    } else {
      my $min;
      for my $ss (@$p) {
        my $sl = len($ss, $d + 1, $max);
        $min = $sl if (!defined $min || $min > $sl);
      }
      $l += $min;
    }
    $cur = $key;
  }
  return $s{$s, $d, $max} = $l;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  for my $l (@$in) {
    my $len1 = len($l, 0, 2);
    my $len2 = len($l, 0, 25);
    $l =~ /([1-9]\d*)/;
    $p1 += $1 * $len1;
    $p2 += $1 * $len2;
  }
  return [$p1, $p2];
}

if ($ENV{GEN_GO}) {
  my @a;
  my @b;
  for my $n (0..999) {
    my $s = sprintf "%03dA", $n;
    push @a, len($s, 0, 2); push @b, len($s, 0, 25);
  }
  print "  depth2 = []int{\n";
  while (@a) {
    my @c = splice @a, 0, 10;
    print "  ".join(", ", @c).",\n";
  }
  print "}\n";
  print "  depth25 = []int{\n";
  while (@b) {
    my @c = splice @b, 0, 5;
    print "  ".join(", ", @c).",\n";
  }
  print "}\n";
  exit;
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
