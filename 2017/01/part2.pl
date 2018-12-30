#!/usr/bin/perl
use warnings;
use strict;

while (<>) {
  chomp;
  my $c = 0;
  for my $i (0..length($_)-1) {
    my $ch = substr $_, $i, 1;
    if ($ch eq substr $_, ($i+length($_)/2) % length($_), 1) {
      $c += $ch;
    }
  }
  print $c, "\n";
}

