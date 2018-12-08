#!/usr/bin/perl -lp
use warnings;
use strict;
$_=parse([split / /]);

sub parse {
  my $e = shift;
  my $s = 0;
  my $c = shift @$e;
  my $m = shift @$e;
  for (1..$c) {
    $s += parse($e);
  }
  for (1..$m) {
    $s += shift @$e;
  }
  return $s;
}
