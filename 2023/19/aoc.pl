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
  my $in = read_chunks($file);
  my %m = ();
  for my $l (split /\n/, $in->[0]) {
    die "1: $l?" unless ($l =~ /^(\w+)\{(.*)}$/);
    print "$l: $1 : $2\n" if DEBUG;
    $m{W}->{$1} = {R => [split /,/, $2]};
  }
  for my $l (split /\n/, $in->[1]) {
    die "2: $l?" unless ($l =~ /^\{(.*)}$/);
    my $list = $1;
    push @{$m{P}}, {map {split /=/, $_} split /,/, $list};
  }
  return \%m;
}

sub solve {
  my ($in, $p, $rn) = @_;
  if ($rn eq 'A') {
    print "A!\n" if DEBUG;
    return sum(values %{$p});
  }
  if ($rn eq 'R') {
    print "R!\n" if DEBUG;
    return 0;
  }
  my $r = $in->{W}->{$rn} // die;
  dd([$r, $p], [qw/r p/]) if DEBUG;
  for my $chk (@{$r->{R}}) {
    if ($chk =~ /^([xmas])([<>])(\d+):(\w+)$/) {
      my ($k, $op, $v, $nxt) = ($1, $2, $3, $4);
      if ($op eq '<') {
        if ($p->{$k} < $v) {
          print "S: $k < $v\n" if DEBUG;
          print "sending to rule $nxt\n" if DEBUG;
          return solve($in, $p, $nxt);
        }
      } else {
        if ($p->{$k} > $v) {
          print "S: $k > $v\n" if DEBUG;
          print "sending to rule $nxt\n" if DEBUG;
          return solve($in, $p, $nxt);
        }
      }
    } else {
      print "sending to rule $chk\n" if DEBUG;
      return solve($in, $p, $chk);
    }
  }
}

sub split_ranges {
  my ($k, $op, $v, $r) = @_;
  my (%t, %f);

  # deep copy unaffected
  for my $k2 (qw/x m a s/) {
    $t{$k2} = [$r->{$k2}->[LO], $r->{$k2}->[HI]];
    $f{$k2} = [$r->{$k2}->[LO], $r->{$k2}->[HI]];
  }
  if ($op eq '>') {
    $t{$k}->[LO] = max($r->{$k}->[LO], $v + 1);
    $f{$k}->[HI] = min($r->{$k}->[HI], $v);
  } else {
    $t{$k}->[HI] = min($r->{$k}->[HI], $v - 1);
    $f{$k}->[LO] = max($r->{$k}->[LO], $v);
  }
  return \%t, \%f;
}

sub solve2 {
  my ($in) = @_;
  my $c = 0;
  my @todo = [
    "in",
    {'x' => [1, 4000], 'm' => [1, 4000], 'a' => [1, 4000], 's' => [1, 4000]}
  ];
  while (@todo) {
    my $cur = shift @todo;
    my ($rn, $ranges) = @$cur;
    if ($rn eq 'A') {
      $c += product(map {$_->[1] - $_->[0] + 1} values %$ranges);
      next;
    }
    if ($rn eq 'R') {
      next;
    }
    my $r = $in->{W}->{$rn} // die "no rule: $rn?";
    dd([$ranges], [$rn]) if DEBUG;
    for my $chk (@{$r->{R}}) {
      print "CHK: $chk\n" if DEBUG;
      if ($chk =~ /^([xmas])([<>])(\d+):(\w+)$/) {
        my ($k, $op, $v, $nxt) = ($1, $2, $3, $4);
        my ($tr, $fr) = split_ranges($k, $op, $v, $ranges);
        dd([$tr, $fr], [qw/tr fr/]) if DEBUG;
        push @todo, [$nxt, $tr];    # matched
        $ranges = $fr;
      } else {
        print "sending to rule $chk\n" if DEBUG;
        push @todo, [$chk, $ranges];
      }
    }
  }
  return $c;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  for my $p (@{$in->{P}}) {
    my $c = solve($in, $p, "in");
    $p1 += $c;
  }
  my $p2 = solve2($in);
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
