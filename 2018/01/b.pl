#!/usr/bin/perl -l

use strict;
use warnings;

my @n = <>;

my $c;
my %seen;
my $s;
while (1) {
  for my $c (@n) {
    $s+=$c;
    if (exists $seen{$s}) {
      print $s;
      exit;
    }
    $seen{$s}++;
  }
}
