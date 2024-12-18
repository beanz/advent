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
  my $in = read_guess($file);
  dd([$in], [qw/in/]);
  my %m;
  for my $i (0 .. @$in - 1) {
    $m{$in->[$i]->[0], $in->[$i]->[1]} = $i;
  }
  if (@$in < 100) {
    return [\%m, [6, 6], 12];
  }
  return [\%m, [70, 70], 1024];
}

use constant {ST => 2,};

sub calc {
  my ($in) = @_;
  dd([$in], [qw/in/]);
  my ($m, $end, $corrupt) = @$in;
  print STDERR "@$end $corrupt\n";
  my ($w, $h) = ($end->[X] + 1, $end->[Y] + 1);
  my $p1 = search($m, $end, $w, $h, $corrupt);
  for my $i ($corrupt+1...10000000) {
    print STDERR "$i\r                   ";
    my $s = search($m, $end, $w, $h, $i);
    unless (defined $s) {
      print STDERR "\n\n";
      return [$p1, $i];
    }
  }
  return [$p1, 0];
}

sub search {
  my ($m, $end, $w, $h, $corrupt) = @_;
  my @todo = [0, 0, 0];
  my %seen;
  while (@todo) {
    my $cur = shift @todo;
    if ($cur->[X] == $end->[X] && $cur->[Y] == $end->[Y]) {
      return $cur->[ST];
    }
    for my $o ([0, -1], [1, 0], [0, 1], [-1, 0]) {
      my ($nx, $ny) = ($cur->[X] + $o->[X], $cur->[Y] + $o->[Y]);
      if (0 <= $nx && $nx < $w && 0 <= $ny && $ny < $h) {
        my $c = $m->{$nx, $ny};
        unless (defined $c && $c < $corrupt) {
          next if ($seen{$nx, $ny});
          $seen{$nx, $ny}++;
          push @todo, [$nx, $ny, $cur->[ST] + 1];
        }
      }
    }
  }
  return;
}

sub pp {
  my ($m, $w, $h, $corrupt, $p) = @_;
  my %p;
  for my $s (@$p) {
    $p{$s->[X], $s->[Y]} = 1;
  }
  dd([\%p]);
  for my $y (0 .. $h - 1) {
    for my $x (0 .. $w - 1) {
      if ($p{$x, $y}) {
        print STDERR "O";
      } elsif (defined $m->{$x, $y} && $m->{$x, $y} < $corrupt) {
        print STDERR "#";
      } else {
        print STDERR ".";
      }
    }
    print STDERR "\n";
  }
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
