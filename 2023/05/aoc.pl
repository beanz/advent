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
  my $in = read_guess($file);
  my $seeds = shift @$in;
  shift @$seeds;
  my %m = (seeds => $seeds, mr => {}, fwd => []);
  my @fwd;
  for my $r (@$in) {
    my $s = (shift @$r)->[0];
    $m{mr}->{$s} = [map {[$_->[1], $_->[1] + $_->[2], $_->[0] + 0]} @$r];
    my ($f, $t) = split(/-to-/, $s);
    push @fwd, $f;
    my $n = "$t-to-$f";
    $m{mr}->{$n} = [map {[$_->[0], $_->[0] + $_->[2], $_->[1] + 0]} @$r];
  }
  push @fwd, "location";
  $m{fwd} = \@fwd;
  $m{bwd} = [reverse @fwd];
  return \%m;
}

sub calc {
  my ($in) = @_;
  return min(map {process_seed($in, $_)} @{$in->{seeds}});
}

sub calc2 {
  my ($in) = @_;
  my $ranges = [map {[$_->[0], $_->[0] + $_->[1]]} pairs @{$in->{seeds}}];
  my $i = 0;
  $SIG{USR1} = sub {print STDERR "$i\n"};
  while (1) {
    my $p = process_seed($in, $i, [@{$in->{bwd}}]);
    for my $r (@$ranges) {
      if (in_range($r, $p)) {
        return $i;
      }
    }
    $i++;
  }
}

sub process_seed {
  my ($in, $p, $steps) = @_;
  $steps = [@{$in->{fwd}}] unless (defined $steps);
  my $prev = shift @$steps;
  for my $next (@$steps) {
    my $mk = "$prev-to-$next";
    print "$p\n" if DEBUG;
    $p = translate($in->{mr}->{$mk}, $p);
    print "  $next $p\n" if DEBUG;
    $prev = $next;
  }
  return $p;
}

sub translate {
  my ($m, $p) = @_;
  for my $r (@$m) {
    if (in_range($r, $p)) {
      my ($s, $e, $d) = @$r;
      my $n = $d + ($p - $s);
      print "found $p in @$r => $n\n" if (DEBUG > 1);
      return $n;
    }
  }
  return $p;
}

sub in_range {
  my ($r, $p) = @_;
  ($r->[0] <= $p && $p < $r->[1]);
}

RunTests(sub {
  my $f = shift; [calc($reader->($f), @_), calc2($reader->($f), @_)]
}) if (TEST);

my $r = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$r;
