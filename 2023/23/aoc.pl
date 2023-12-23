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
  my %m = (m => [map {[split //, $_]} @$in]);
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
  }
  $m{w} = @{$m{m}->[0]};
  $m{h} = @$in;
  return \%m;
}

sub graph {
  my ($in, $part1) = @_;
  my $w = $in->{w};
  my $h = $in->{h};
  my %g;
  my @todo = [1, 0, 1, 0, 0, {}];
  my ($tx, $ty) = ($in->{w} - 2, $in->{h} - 1);
  my %vn;
  while (defined(my $cur = shift @todo)) {
    my ($x, $y, $sx, $sy, $steps, $v) = @$cur;
    next if (exists $v->{$x, $y});
    $v->{$x, $y}++;
    my $ch = $in->{m}->[$y]->[$x];
    my @n;
    for my $o ([-1, 0, '<'], [1, 0, '>'], [0, 1, 'v'], [0, -1, '^']) {
      my ($nx, $ny) = ($x + $o->[0], $y + $o->[1]);
      next unless ($nx >= 0 && $ny >= 0 && $nx < $w - 1 && $ny < $h);
      my $nch = $in->{m}->[$ny]->[$nx];
      next if ($nch eq '#');
      next
        if (($part1 && ($ch ne '.' && $ch ne $o->[2]))
        || (!$part1 && $ch eq '#'));
      push @n, [$nx, $ny];
    }
    if (@n > 2 || ($x == $tx && $y == $ty)) {
      $g{$sx, $sy}->{$x, $y} = $steps;
      next if ($vn{$x, $y});
      $vn{$x, $y}++;
      push @todo, [$_->[0], $_->[1], $x, $y, 1, {"$x,$y" => 1}] for (@n);
      next;
    }
    push @todo, [$_->[0], $_->[1], $sx, $sy, $steps + 1, $v] for (@n);
  }

  #dd([\%g],[qw/g/]);
  @todo = ["1,0", 0, {}, "1,0"];
  my $end = "$tx,$ty";
  my $res = 0;
  while (defined(my $cur = shift @todo)) {
    my ($node, $steps, $v, $path) = @$cur;
    if ($node eq $end) {
      if ($res < $steps) {
        $res = $steps;
      }
      next;
    }
    for my $nxt (sort { $g{$node}->{$b} <=> $g{$node}->{$a} } keys %{$g{$node}}) {
      next if (exists $v->{$nxt});
      my %vn = %{$v};
      $vn{$nxt}++;
      unshift @todo, [
        $nxt, $steps + $g{$node}->{$nxt}, \%vn, $path.", ".$nxt,
      ];
    }
  }
  return $res;
}

sub calc {
  my ($in) = @_;
  my $p1 = graph($in, 1);
  my $p2 = graph($in, 0);
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
