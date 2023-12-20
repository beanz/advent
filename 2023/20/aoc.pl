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

use constant {
  LO => 0,
  HI => 1,
};

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my ($name, $out) = split / -> /, $l;
    if ($name eq 'broadcaster') {
      $m{$name} = {O => [split /, /, $out]};
      next;
    }
    my $type = substr $name, 0, 1, '';
    $m{$name} = {T => $type, O => [split /, /, $out], S => LO};
  }
  for my $m (keys %m) {
    for my $o (@{$m{$m}->{O}}) {
      $m{$o}->{I}->{$m} = LO;
    }
  }
  $m{'button'}->{O} = ['broadcaster'];
  $m{'output'} = {O => [], T => 'O'};
  return \%m;
}

sub sig {
  my ($in, $start, $start_sig, $c, $res, $C) = @_;
  my @todo;
  push @todo, [$start, $start_sig];
  while (@todo) {
    my $cur = shift @todo;
    my ($n, $sig) = @$cur;
    next if ($n eq 'output');
    for my $m (@{$in->{$n}->{O}}) {
      $c->[$sig]++;

      #print "$n ", $sig, "> $m\n";
      if ($m eq 'rx') {
        next;
      }
      if ($m eq 'broadcaster') {
        push @todo, [$m, $sig];
      } elsif ($in->{$m}->{T} eq '%') {
        if ($sig == LO) {
          $in->{$m}->{S} = !$in->{$m}->{S};
          push @todo, [$m, $in->{$m}->{S}];
        }
      } elsif ($in->{$m}->{T} eq '&') {
        $in->{$m}->{I}->{$n} = $sig;
        my $s = HI;
        for my $i (keys %{$in->{$m}->{I}}) {
          $s &&= $in->{$m}->{I}->{$i};
        }
        if ($s) {
          push @todo, [$m, LO];
        } else {
          $res->{$m} = $C;
          push @todo, [$m, HI];
        }
      }
    }
  }
}

sub calc {
  my ($in) = @_;

  #dd([$in], [qw/in/]);
  my @c = (0, 0);
  my %res;
  for (0 .. 999) {
    sig($in, 'button', LO, \@c, \%res, $_);
  }
  my $p1 = $c[LO] * $c[HI];
  return [$p1, 0] unless (exists $in->{rx});
  my $C = 1000;
  my @rx = keys %{$in->{rx}->{I}};
  my @important = keys %{$in->{$rx[0]}->{I}};
  while (1) {
    sig($in, 'button', LO, \@c, \%res, $C);
    my $found = 1;
    for my $k (@important) {
      if (exists $res{$k}) {
        next;
      }
      $found = 0;
      last;
    }
    last if ($found);
    $C++;
  }
  my $p2 = product(map {$res{$_} + 1} @important);
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
