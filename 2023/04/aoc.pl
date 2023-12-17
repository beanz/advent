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

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  my @copies;
  for my $l (@$in) {
    my ($c, $a, $b) = split /[:\|]/, $l;
    my %a = map {$_ => 1} ($a =~ m/\d+/g);
    my $p = 0;
    for my $o ($b =~ m/\d+/g) {
      if (exists $a{$o}) {
        $p++;
      }
    }
    $p1 += 2**($p - 1) if ($p);
    my $n = 1;
    for (@copies) {
      $_->[0]--;
      $n+=$_->[1];
    }
    @copies = grep {$_->[0] > 0} @copies;
    print STDERR "N: $n\n" if DEBUG;
    $p2 += $n;
    push @copies, [$p, $n] if ($p);
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $r = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$r;
