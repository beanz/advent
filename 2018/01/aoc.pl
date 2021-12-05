#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $s = 0;
for (@i) {
  $s+=$_;
}
print 'Part 1: ', $s, "\n";

my $c;
my %seen;
$s = 0;
while (1) {
  for my $c (@i) {
    $s+=$c;
    if (exists $seen{$s}) {
      print 'Part 2: ', $s, "\n";
      exit;
    }
    $seen{$s}++;
  }
}
