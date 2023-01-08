#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use Carp::Always qw/carp verbose/;

$| = 1;
$_ = <>;
my @i = split /,/;

my $map_start = 1182;
my $map_end = $i[11] + $i[12];
my $w = $i[828];
my $sx = $i[576];
my $sy = $i[577];

my @CH = ('.', '#');
my $map = "";
my $j = 0;
for my $i ($map_start .. $map_end - 1) {
  my $n = $i[$i];
  $map .= $CH[$j] x $n;
  $j = 1 - $j;
}
my $h = int(length($map) / $w);
my @m = split //, $map;
my $p1 = 0;
my $p2 = 0;
my $c = 0;
for my $y (0 .. $h - 1) {
  for my $x (0 .. $w - 1) {
    my $i = $y * $w + $x;
    if ($x == $sx && $y == $sy) {
      print '^';
    } else {
      print $m[$i];
    }
    next if ($m[$i] eq '.');
    if ($x > 1 && $x < $w - 1 && $y > 1) {
      if ($m[$i + 1] eq '#' && $m[$i - 1] eq '#' && $m[$i - $w] eq '#') {
        $p1 += $x * $y;
      }
    }
    $c++;

    #print "$x,$y\n";
    $p2 += $map_end + ($y * $w + $x);

    #print "adding ",$map_end+($y*$w+$x), " = $p2\n";
    $p2 += $x * $y;

    #print "adding ", $x*$y, " = $p2\n";
  }
  print "\n";
}
print "Part 1: $p1\n";
$p2 += (1 + $c) * $c / 2;
print "Part 2: $p2\n";

#print "Start: $sx,$sy\n";
print "$w x $h\n";
