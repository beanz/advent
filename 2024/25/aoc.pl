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
  my %m;
  for my $i (0 .. (@$in - 1)) {
    my $type = $in->[$i]->[0] eq '#####' ? "lock" : 'key';
    my @c = (-1, -1, -1, -1, -1);
    for my $l (@{$in->[$i]}) {
      my @l = split //, $l;
      for my $j (0 .. $#l) {
        $c[$j]++ if ($l[$j] eq '#');
      }
    }
    push @{$m{$type}}, \@c;
  }
  return \%m;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  for my $k (@{$in->{key}}) {
  LOCK:
    for my $l (@{$in->{lock}}) {
      for my $i (0 .. 4) {
        if ($k->[$i] + $l->[$i] > 5) {
          next LOCK;
        }
      }
      $p1++;
    }
  }
  return [$p1, 0];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
