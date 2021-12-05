#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};
@i = sort @i;

my $guard;
my $g;
my $s;
my %g;
for (@i) {
  if (/#(\d+)/) {
    $g = $1;
  } elsif (/(\d\d)\]\s+falls/) {
    $s = $1;
  } elsif (/(\d\d)\]\s+wakes/) {
    $g{$g}->{c} += $1-$s;
    if (!defined $guard || $g{$g}->{c} > $g{$guard}->{c}) {
      $guard = $g;
    }
    for my $m($s..$1-1) {
      $g{$g}->{m}->{$m}++;
      if (!defined $g{$g}->{maxm} ||
          $g{$g}->{m}->{$m} > $g{$g}->{m}->{$g{$g}->{maxm}}) {
        $g{$g}->{maxm} = $m;
      }
    }
  }
}

print 'Part 1: ', $guard * $g{$guard}->{maxm}, "\n";

{
  my $guard;
  my $max_min;
  my $g;
  my $s;
  my %g;
  for (@i) {
    if (/#(\d+)/) {
      $g = $1;
    } elsif (/(\d\d)\]\s+falls/) {
      $s = $1;
    } elsif (/(\d\d)\]\s+wakes/) {
      for my $m($s..$1-1) {
        $g{$g}->{$m}++;
        if (!exists $g{$g}->{max} || $g{$g}->{max} <= $g{$g}->{$m}) {
          $g{$g}->{max} = $g{$g}->{$m};
          if (!defined $guard || $g{$g}->{max} > $g{$guard}->{max}) {
            $guard = $g;
            $max_min = $m;
          }
        }
      }
    }
  }
  print 'Part 2: ', $guard * $max_min, "\n";
}



