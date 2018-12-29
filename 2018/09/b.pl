#!/usr/bin/perl -l

use warnings;
use strict;

unless (defined caller) {
  while (<>) {
    if (/(\d+) players; last marble is worth (\d+) points/) {
      print play_fast($1,$2);
    }
  }
}

sub ppf {
  my ($c) = @_;
  print join " ", @$c;
}

sub play_fast {
  my ($players, $num) = @_;
  #print "$players $num";
  my $ms = 0;
  my @s;
  my @c = (0);
  #ppf(\@c);
  for my $m (1..$num) {
    if (($m%23)==0) {
      $s[($m-1)%$players]+=$m;
      unshift @c, pop @c for (1..7);
      my $r = shift @c;
      $s[($m-1)%$players]+=$r;
      if ($s[($m-1)%$players] > $ms) {
        $ms = $s[($m-1)%$players];
      }
    } else {
      push @c, shift @c for (1..2);
      unshift @c, $m;
    }
    #ppf(\@c);
  }
  return $ms;
}

1;
