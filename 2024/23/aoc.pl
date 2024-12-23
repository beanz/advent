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
  my %g;
  for my $i (0 .. (@$in - 1)) {
    my ($a, $b) = split /-/, $in->[$i];
    $g{$a}->{$b} = 1;
    $g{$b}->{$a} = 1;
  }
  return \%g;
}

sub calc {
  my ($in) = @_;
  my %p;
  for my $k (keys %$in) {
    next unless ($k =~ /^t/);
    my @t = keys %{$in->{$k}};
    for my $i (0 .. $#t) {
      for my $j ($i + 1 .. $#t) {
        if ($in->{$t[$i]}->{$t[$j]}) {
          my $k = join ',', sort {$a cmp $b} $k, $t[$i], $t[$j];
          $p{$k}++;
        }
      }
    }
  }
  my $p1 = keys %p;
  my $c = [];
  bk([], [keys %$in], [], $in, $c);
  my @c;
  for my $cc (@$c) {
    @c = @$cc if (@$cc > @c);
  }
  my $p2 = join ',', uniq sort {$a cmp $b} @c;
  return [$p1, $p2];
}

sub bk {
  my ($r, $p, $x, $g, $c) = @_;
  if (@$p == 0 && @$x == 0) {
    push @$c, $r;
    return;
  }
  while (@$p) {
    my $n = shift @$p;
    my @r = @$r;
    push @r, $n;
    my @p;
    my @x;
    for my $nn (@$p) {
      push @p, $nn if ($g->{$n}->{$nn});
    }
    for my $nn (@$x) {
      push @x, $nn if ($g->{$n}->{$nn});
    }
    bk(\@r, \@p, \@x, $g, $c);
    push @$x, $n;
  }
  return;
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
