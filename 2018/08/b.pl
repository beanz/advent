#!/usr/bin/perl -lp
use warnings;
use strict;
$_=parse([split / /]);

sub parse {
  my $e = shift;
  my $s = 0;
  my $c = shift @$e;
  my $m = shift @$e;
  if ($c) {
    my @c;
    for (1..$c) {
      push @c, parse($e);
    }
    for (1..$m) {
      my $me = shift @$e;
      $s += $c[$me-1] if ($me <= @c);
    }
  } else {
    for (1..$m) {
      $s += shift @$e;
    }
  }
  return $s;
}

