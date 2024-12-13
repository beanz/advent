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
  my $in = read_2024($file);
  my %m = (a => [], b => [], ac => {}, bc => {});
  for (@$in) {
    my ($a, $b) = @$_;
    push @{$m{a}}, $a;
    push @{$m{b}}, $b;
    $m{ac}->{$a}++;
    $m{bc}->{$b}++;
  }
  return \%m;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my @a = sort {$a <=> $b} @{$in->{a}};
  my @b = sort {$a <=> $b} @{$in->{b}};
  for my $i (0 .. $#a) {
    $p1 += abs($a[$i] - $b[$i]);
  }
  my $p2 = 0;
  for my $a (keys %{$in->{ac}}) {
    $p2 += $a * $in->{ac}->{$a} * ($in->{bc}->{$a} // 0);
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
