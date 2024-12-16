#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

use Carp::Always qw/carp verbose/;

#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

use constant {
  DX => [0, 1, 0, -1],
  DY => [-1, 0, 1, 0],
  DO => [0, 1, -1, 2],
};

use POE::XS::Queue::Array;

sub calc {
  my ($m) = @_;
  my $p1;
  my ($sx, $sy) = (1, $m->height - 2);
  my ($tx, $ty) = ($m->width - 2, 1);
  my $todo = POE::XS::Queue::Array->new();
  $todo->enqueue(0, [$sx, $sy, 1, 0, []]);
  my %seen;
  my %sd;

  while (1) {
    my ($pri, $qid, $cur) = $todo->dequeue_next();
    last unless (defined $pri);
    my ($x, $y, $dir, $st, $path) = @$cur;
    $sd{$x, $y, $dir} = $st unless (exists $sd{$x, $y, $dir});
    if ($x == $tx && $y == $ty) {
      $p1 = $st unless (defined $p1);
      pp($m, $path) if DEBUG;
    }
    if (exists $seen{$x, $y, $dir}) {
      next;
    }
    $seen{$x, $y, $dir}++;

    my ($nx, $ny) = ($x + DX->[$dir], $y + DY->[$dir]);
    if ($m->get($nx, $ny) ne '#') {
      $todo->enqueue($st + 1, [$nx, $ny, $dir, $st + 1, [@$path, [$nx, $ny]]]);
    }
    $todo->enqueue($st + 1000,
      [$x, $y, ($dir + 1) & 3, $st + 1000, [@$path, [$x, $y]]]);
    $todo->enqueue($st + 1000,
      [$x, $y, ($dir + 3) & 3, $st + 1000, [@$path, [$x, $y]]]);
  }
  $todo = POE::XS::Queue::Array->new();
  for my $dir (0 .. 3) {
    $todo->enqueue(0, [$tx, $ty, $dir, 0, []]);
  }
  %seen = ();
  my %ed;
  while (1) {
    my ($pri, $qid, $cur) = $todo->dequeue_next();
    last unless (defined $pri);
    my ($x, $y, $dir, $st, $path) = @$cur;
    $ed{$x, $y, $dir} = $st unless (exists $ed{$x, $y, $dir});
    if (exists $seen{$x, $y, $dir}) {
      next;
    }
    $seen{$x, $y, $dir}++;
    my ($nx, $ny) = ($x - DX->[$dir], $y - DY->[$dir]);
    if ($m->get($nx, $ny) ne '#') {
      $todo->enqueue($st + 1, [$nx, $ny, $dir, $st + 1, [@$path, [$nx, $ny]]]);
    }
    $todo->enqueue($st + 1000,
      [$x, $y, ($dir + 1) & 3, $st + 1000, [@$path, [$x, $y]]]);
    $todo->enqueue($st + 1000,
      [$x, $y, ($dir + 3) & 3, $st + 1000, [@$path, [$x, $y]]]);
  }
  my %o;
  for my $y (0 .. $m->height - 1) {
    for my $x (0 .. $m->width - 1) {
      for my $dir (0 .. 3) {
        my $sd = $sd{$x, $y, $dir} // next;
        my $ed = $ed{$x, $y, $dir} // next;
        $o{$x, $y}++ if ($sd + $ed == $p1);
      }
    }
  }
  my $p2 = keys %o;
  return [$p1, $p2];
}

sub pp {
  my ($m, $path) = @_;
  my ($sx, $sy) = (1, $m->height - 2);
  my ($tx, $ty) = ($m->width - 2, 1);
  my %p;
  for (@$path) {
    $p{$_->[0], $_->[1]} = 1;
  }
  for my $y (0 .. $m->height - 1) {
    for my $x (0 .. $m->width - 1) {
      if ($x == $sx && $y == $sy) {
        print STDERR "S";
      } elsif ($x == $tx && $y == $ty) {
        print STDERR "E";
      } elsif ($p{$x, $y}) {
        print STDERR '^';
      } else {
        print STDERR $m->get($x, $y);
      }
    }
    print STDERR "\n";
  }
  print STDERR join(' ', map {$_->[0] . ',' . $_->[1]} @$path), "\n";
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
