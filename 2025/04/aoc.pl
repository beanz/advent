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

#my $reader = \&read_stuff;
my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m = (lines => $in);
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    print "$i: $l\n";
  }
  return \%m;
}

sub calc {
  my ($in) = @_;
  my $p1 = 0;
    $in->visit_xy(
      sub {
        my ($m, $x, $y, $ch) = @_;
        my $c = 0;
        if ($ch ne '@') {
          return;
        }
        for ($m->neighbours8($m->index($x, $y))) {
          $c++ if ($m->get_idx($_) eq '@');
        }
        if ($c < 4) {
          $p1++;
        }
      }
    );
  my $p2 = 0;
  my $done;
  while (!$done) {
    $done = 1;
    $in->visit_xy(
      sub {
        my ($m, $x, $y, $ch) = @_;
        my $c = 0;
        if ($ch ne '@') {
          return;
        }
        for ($m->neighbours8($m->index($x, $y))) {
          $c++ if ($m->get_idx($_) eq '@');
        }
        if ($c < 4) {
          $done = 0;
          $m->set($x,$y, '_');
          $p2++;
        }
      }
    );
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
