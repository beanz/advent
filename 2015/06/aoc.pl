#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my %fn =
  (
   'turn on' => sub { my ($l, $x, $y) = @_; $l->{$x.'.'.$y}++; },
   'turn off'=> sub { my ($l, $x, $y) = @_; delete $l->{$x.'.'.$y}; },
   'toggle' => sub {
     my ($l, $x, $y) = @_;
     my $k = $x.'.'.$y;
     if (exists $l->{$k}) {
       delete $l->{$k};
     } else {
       $l->{$k}++;
     }
   },
  );

sub apply {
  my ($l, $i) = @_;
  my ($cmd, $minX, $minY, $maxX, $maxY) =
    ($i =~ /(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/) or die;
  my $fn = $fn{$cmd} or die;
  for my $x ($minX..$maxX) {
    for my $y ($minY..$maxY) {
      $fn->($l, $x, $y);
    }
  }
}

my %fn2 =
  (
   'turn on' => sub { my ($l, $x, $y) = @_; $l->{$x.'.'.$y}++; return 1; },
   'turn off'=> sub {
     my ($l, $x, $y) = @_;
     my $k = $x.'.'.$y;
     if (exists $l->{$k} && $l->{$k} > 0) {
       $l->{$k}--;
       return -1;
     } else {
       return 0;
     }
   },
   'toggle' => sub { my ($l, $x, $y) = @_; $l->{$x.'.'.$y}+=2; return 2; },
  );

if (TEST) {
  my %l = ();
  apply(\%l, "turn on 0,0 through 999,999");
  assertEq("turn on 0,0 through 999,999", ~~keys%l, 1000000);
  apply(\%l, "toggle 0,0 through 999,0");
  assertEq("toggle 0,0 through 999,0", ~~keys%l, 999000);
  apply(\%l, "turn off 499,499 through 500,500");
  assertEq("turn off 499,499 through 500,500", ~~keys%l, 998996);
}

my %l = ();
my @i = @{read_lines(shift//"input.txt")};
for my $i (@i) {
  apply(\%l, $i);
}
print "Part 1: ", ~~keys%l, "\n";

sub apply2 {
  my ($s, $i) = @_;
  my ($cmd, $minX, $minY, $maxX, $maxY) =
    ($i =~ /(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/) or die;
  my $fn = $fn2{$cmd} or die;
  for my $x ($minX..$maxX) {
    for my $y ($minY..$maxY) {
      $s->[1] += $fn->($s->[0], $x, $y);
    }
  }
  return;
}

if (TEST) {
  my @s = ({}, 0);
  apply2(\@s, "turn on 0,0 through 0,0");
  assertEq("turn on 0,0 through 0,0", $s[1], 1);
  apply2(\@s, "toggle 0,0 through 999,999");
  assertEq("toggle 0,0 through 999,999", $s[1], 2000001);
}

my @s = ({}, 0);
for my $i (@i) {
  apply2(\@s, $i);
}
print "Part 2: ", $s[1], "\n";
