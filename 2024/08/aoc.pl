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

my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my %p1;
  my %p2;
  my %d;
  $in->visit_xy(
    sub {
      my ($m, $x, $y, $ch) = @_;
      return if ($ch eq '.');
      push @{$d{$ch}}, [$x, $y];
    }
  );

  for my $ch (keys %d) {
    my @l = @{$d{$ch}};
    for my $i (0 .. $#l) {
      for my $j ($i + 1 .. $#l) {
        my ($a, $b) = ($l[$i], $l[$j]);
        $p2{$a->[X], $a->[Y]}++;
        $p2{$b->[X], $b->[Y]}++;
        my ($dx, $dy) = ($a->[X] - $b->[X], $a->[Y] - $b->[Y]);
        my ($x, $y) = ($a->[X] + $dx, $a->[Y] + $dy);
        if ($in->in($x, $y)) {
          $p1{$x, $y}++;
          $p2{$x, $y}++;
          while (1) {
            ($x, $y) = ($x + $dx, $y + $dy);
            if ($in->in($x, $y)) {
              $p2{$x, $y}++;
              next;
            }
            last;
          }
        }

        ($x, $y) = ($b->[X] - $dx, $b->[Y] - $dy);
        if ($in->in($x, $y)) {
          $p1{$x, $y}++;
          $p2{$x, $y}++;
          while (1) {
            ($x, $y) = ($x - $dx, $y - $dy);
            if ($in->in($x, $y)) {
              $p2{$x, $y}++;
              next;
            }
            last;
          }
        }
      }
    }
  }
  if (DEBUG) {
    for my $y (0 .. $in->height - 1) {
      for my $x (0 .. $in->width - 1) {
        my $ch = $in->get($x, $y);
        if ($p2{$x, $y}) {
          $ch = '#' if ($ch eq '.');
          if ($p1{$x, $y}) {
            print STDERR bold(red($ch));
          } else {
            print STDERR bold($ch);
          }
        } else {
          print STDERR $ch;
        }
      }
      print STDERR "\n";
    }
  }
  return [~~ keys %p1, ~~ keys %p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
