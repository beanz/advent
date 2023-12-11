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
  my $in = read_lines($file);
  my @r;
  for (@$in) {
    my ($h, $b) = split/\s+/, $_;
    $h =~ y/TJQKA/ABCDE/;
    my $h2 = $h;
    $h2 =~ y/B/0/;
    push @r, [[$h, score($h)], [$h2, score2($h2)], $b, $_];
  }
  return \@r;
}

sub score {
  my ($h) = @_;
  my %c;
  for (split //, $h) {
    $c{$_}++;
  }
  my @cc = sort {$b <=> $a} values %c;
  if (@cc == 1) {
    return 0;
  }
  if ($cc[0] == 4) {
    return 1;
  }
  if ($cc[0] == 3) {
    if (@cc == 2) {
      return 2;
    }
    return 3;
  }
  if ($cc[0] == 2) {
    if ($cc[1] == 2) {
      return 4;
    }
    return 5;
  }
  return 9;
}

sub comp {
  my ($a, $b) = @_;
  my ($sa) = $a->[1];
  my ($sb) = $b->[1];
  if ($sa == $sb) {
    return $a->[0] cmp $b->[0];
  }
  return $b->[1] <=> $a->[1];
}

sub score2 {
  my ($h) = @_;
  my $b = score($h);
  if ($h !~ /0/) {
    return $b;
  }
  for (qw/1 2 3 4 5 6 7 8 9 A C D E/) {
    my $hh = $h;
    $hh =~ s/0/$_/g;
    my $n = score($hh);
    $b = $n if ($b > $n);
  }
  return $b;
}

sub solve {
  my ($in, $by) = @_;
  $by //= 0;
  my $c = 0;
  my @s = sort {comp($a->[$by], $b->[$by])} @$in;
  for my $i (0 .. @s - 1) {
    my ($h, undef, $b) = @{$s[$i]};
    $c += $b * ($i + 1);
  }
  return $c;
}

sub calc {
  [solve(@_), solve(@_, 1)]
}

RunTests(sub { my $f = shift; calc($reader->($f), @_) }) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
