#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_guess;
my $i = $reader->($file);

sub calc1 {
  my ($in) = @_;
  my $c = 0;
  for (@$in) {
    $c += 10 * $1 if (/^.*?(\d)/);
    $c += $1 if (/^.*(\d)/);
  }
  return $c;
}

my %n = (
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
);
for (1 .. 9) {
  $n{$_} = $_;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  my $p = '(' . (join '|', keys %n) . ')';
  for (@$in) {
    $c += 10 * $n{$1} if (/^.*?$p/o);
    $c += $n{$+} if (/^.*$p/o);
  }
  return $c;
}

sub calc {
  my ($in) = @_;
  return [calc1($in), calc2($in)];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
