#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

#use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/permutations combinations variations/;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_stuff;
my $i = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %g;
  print STDERR "digraph {\n" if DEBUG;
  for my $i (0 .. (@$in - 1)) {
    my ($f, @r) = split /:?\s+/, $in->[$i];
    for (@r) {
      my @a = sort ($f, $_);
      $g{$a[0]}->{$a[1]}++;
      $g{$a[1]}->{$a[0]}++;
      print STDERR "  $a[0] -> $a[1]\n" if DEBUG;
    }
  }
  print STDERR "}\n" if DEBUG;
  return \%g;
}

sub size {
  my ($g) = @_;
  my %p;
  my @k = keys %$g;
  for my $k (@k) {
    next if (exists $p{$k});
    my @todo = $k;
    while (defined(my $cur = pop @todo)) {
      next if (exists $p{$cur});
      $p{$cur} = $k;
      for my $n (keys %{$g->{$cur}}) {
        push @todo, $n unless (exists $p{$n});
      }
    }
  }
  my %r;
  for my $k (keys %p) {
    $r{$p{$k}}++;
  }
  my $size = scalar keys %r;
  if ($size == 2) {
    my $p = 1;
    for my $v (values %r) {
      return 1 if ($v == 1);
      $p *= $v;
    }
    return $p;
  }
  return 1;
}

sub find_path {
  my ($in, $start, $end, $cut) = @_;
  my @todo = [$start];
  my %v;
  while (defined(my $cur = shift @todo)) {
    my $n = $cur->[@$cur - 1];
    if ($n eq $end) {
      return $cur;
    }
    $v{$n}++;
    for my $nxt (keys %{$in->{$n}}) {
      my $edge = join '!', sort ($n, $nxt);
      next if (exists $cut->{$edge});
      push @todo, [@$cur, $nxt] unless (exists $v{$nxt});
    }
  }
  return;
}

sub find_cuts {
  my ($in, $start, $end) = @_;
  print STDERR "checking paths between $start and $end\n" if DEBUG;
  my %cut;
  for my $k (0 .. 2) {
    my $path = find_path($in, $start, $end, \%cut);
    if (!defined $path) {
      return;    # didn't manage three cuts?
    }
    print "found ", ($k + 1), " path(s)\n" if DEBUG;
    for my $i (0 .. @$path - 2) {
      my $edge = join '!', sort $path->[$i], $path->[$i + 1];
      print "C: $edge\n" if DEBUG;
      $cut{$edge} = 1;
    }
  }
  my $path = find_path($in, $start, $end, \%cut);
  if (defined $path) {

    # still connected so both points are in same partition; try again
    return;
  }
  my @edges = keys %cut;
  for my $edge (@edges) {
    print STDERR "putting $edge back\n" if (DEBUG > 1);
    delete $cut{$edge};
    my $path = find_path($in, $start, $end, \%cut);
    if (defined $path) {
      print STDERR "$edge is needed cut\n" if DEBUG;
      $cut{$edge} = 1;
    }
  }

  for my $k (keys %cut) {
    my ($a, $b) = split /!/, $k;
    delete $in->{$a}->{$b};
    delete $in->{$b}->{$a};
  }

  return size($in);
}

sub calc {
  my ($in) = @_;
  my @nodes = keys %$in;
  my $iter = variations(\@nodes, 2);
  my $cut;
  while (defined(my $se = $iter->next)) {

    #$cut = find_cuts_slow($in, $se->[0], $se->[1], {}, {});
    $cut = find_cuts($in, $se->[0], $se->[1]);
    return [$cut, 1] if ($cut);
  }
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\n", $res->[0];
