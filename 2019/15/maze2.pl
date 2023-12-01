#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use Carp::Always qw/carp verbose/;

$| = 1;
$_ = <>;
my @i = split /,/;
my $w = $i[132];
my $h = $i[139];
my $sx = $i[1034];
my $sy = $i[1035];
my $ox = $i[146];
my $oy = $i[153];
my $wall_base = 252;
my $cutoff = $i[212];

sub wall_index {
  my ($x, $y) = @_;
  my $wy = int(($y-1+$y%2)/2);
  $wall_base+($wy*39+$x-1)
}

for my $y (0 .. $h) {
  for my $x (0 .. $w) {
    if ($x == 0 || $y == 0 || $x==$w || $y == $w) {
      print "#";
      next;
    }
    if ($x == $sx && $y == $sy) {
      print "S";
      next;
    }
    if ($x == $ox && $y == $oy) {
      print "O";
      next;
    }
    my $mx = $x % 2;
    my $my = $y % 2;
    if ($mx == 1 && $my == 1) {
      print ".";
      next;
    }
    if ($mx == 0 && $my == 0) {
      print "#";
      next;
    }
    my $wi = wall_index($x,$y);
    if ($i[$wi] < $cutoff) {
      print ".";
    } else {
      print "#";
    }
  }
  print "\n";
}
