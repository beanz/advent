#!/usr/bin/perl -l
use warnings;
use strict;
my @a = <>;
chomp @a;
my $guard;
my $max_min;
my $g;
my $s;
my %g;
for (sort @a) {
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

print $guard * $max_min;

