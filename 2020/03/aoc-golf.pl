#!/usr/bin/perl -0n
use warnings;
use strict;
my $w=index$_,"\n";
my $h=y/\n//;
my $i=$_;
sub t {
  my ($x,$y) = @_;
  $_=$i;
  my $wx=int 1+$x*$h/$y/$w;
  s/(.{$w})\n/$1 x$wx/eg;
  my $d=$x+$wx*$w*$y-1;
  s/(.).{1,$d}/$1/g;
  y/#//;
}
print t(3,1)," ",t(3,1)*t(1,1)*t(5,1)*t(7,1)*t(1,2),"\n";


