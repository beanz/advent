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
  my @r;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    print "$i: $l\n";
    my @s = split /\s+/, $l;
    my $res = shift @s;
    $res = substr($res, 1, -1);
    my $n = length $res;
    my $j = pop @s;
    $j = [split /,/, substr($j, 1, -1)];
    my @b = map {[split /,/, substr $_, 1, -1]} @s;
    my %rec = (
      n => $n,
      r => $res,
      j => $j,
      b => \@b,
    );
    push @r, \%rec;
  }
  return \@r;
}

sub search {
  my ($l, $c, $e) = @_;
  my @todo = [$c, 0];
  my %s;
  while (@todo) {
    my ($c, $n) = @{shift @todo};
    return $n if ($c == $e);
    next if ($s{$c});
    $s{$c}++;
    for my $b (@{$l->{b}}) {
      #print " B:@{$b}\n";
      my $nc = $c;
      for my $p (@$b) {
        $nc ^= (1 << $p);
      }
      push @todo, [$nc, $n + 1];
    }
  }
  return -1;
}

sub search2 {
  my ($l, $init) = @_;
  my @todo = [$init, 0];
  my %s;
  LOOP:
  while (@todo) {
    my ($c, $n) = @{shift @todo};
    print STDERR ~~@todo, "\r";
    next if ($s{"@$c"});
    #print "@$c\n";
    for (0..@$c-1) {
      next LOOP if ($c->[$_] > $l->{j}->[$_]);
    }
    return $n if ("@$c" eq "@{$l->{j}}");
    for my $b (@{$l->{b}}) {
      my $nc = [@$c];
      for my $p (@$b) {
        $nc->[$p]++;
      }
      push @todo, [$nc, $n + 1];
    }
  }
  return -1;
}


sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  for my $l (@$in) {
    my $res = reverse $l->{r};
    my $n = 0;
    for my $b (split //, $res) {
      $n = ($n << 1) + ($b eq '#' ? 1 : 0);
    }
    $p1 += search($l, 0, $n);
    my $i = [(0) x $l->{n}];
    #$p2 += search2($l, $i);
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
