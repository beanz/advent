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

my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub parts {
  my ($in) = @_;
  my ($p1, $p2) = (0, 0);
  for (@$in) {
    /^Game (\d+): (.*)$/ || die "bad input? $_\n";
    my ($id, $rest) = ($1, $2);
    my $possible = 1;
    my %m = (map {$_ => 1} qw/red blue green/);
    for my $set (split /;\s*/, $rest) {
      my %r = (map {$_ => 0} qw/red blue green/);
      for my $r (split /,\s*/, $set) {
        my ($n, $c) = split / /, $r;
        $r{$c} = $n;
        $m{$c} = $r{$c} if ($m{$c} < $r{$c});
      }
      if ($r{red} > 12 || $r{green} > 13 || $r{blue} > 14) {
        $possible = undef;
      }
    }
    if ($possible) {
      $p1 += $id;
    }
    $p2 += $m{red} * $m{green} * $m{blue};
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; parts($reader->($f), @_)}) if (TEST);

my $r = parts($i);
printf "Part 1: %s\nPart 2: %s\n", @$r;
