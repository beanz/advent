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

my $reader = \&read_dense_map;
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
      my ($in, $x, $y, $ch) = @_;
      return unless ($ch eq 'X');
      for my $o ([-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1],
        [1, 1])
      {
        my $ni = $in->index($x + $o->[X], $y + $o->[Y]) // next;
        next unless ($in->get_idx($ni) eq 'M');
        $ni = $in->index($x + $o->[X] * 2, $y + $o->[Y] * 2) // next;
        next unless ($in->get_idx($ni) eq 'A');
        $ni = $in->index($x + $o->[X] * 3, $y + $o->[Y] * 3) // next;
        next unless ($in->get_idx($ni) eq 'S');
        $p1++;
      }
    }
  );
  my $p2 = 0;
  $in->visit_xy(
    sub {
      my ($in, $x, $y, $ch) = @_;
      return unless ($ch eq 'A');
      for my $o ([-1, -1], [1, -1]) {
        my $ni = $in->index($x + $o->[X], $y + $o->[Y]) // return;
        my $oi = $in->index($x - $o->[X], $y - $o->[Y]) // return;
        my $s = $in->get_idx($ni) . $ch . $in->get_idx($oi);
        return
          unless (($in->get_idx($ni) eq 'M' && $in->get_idx($oi) eq 'S')
          || ($in->get_idx($ni) eq 'S' && $in->get_idx($oi) eq 'M'));
      }
      $p2++;
    }
  );
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
