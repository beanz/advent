#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use constant { X => 0, Y => 1 };

my $serial = <>;
my $size = <>;
$size =~ s/\s+.*//;
my $grid_min = <>;
$grid_min = [ split /\s+/, $grid_min ];
my $grid_max = <>;
$grid_max = [ split /\s+/, $grid_max ];

my $max;
my $max_id;
my %p;
for my $y ($grid_min->[Y] .. $grid_max->[Y]-$size+1) {
  #print STDERR "$y\r";
  for my $x ($grid_min->[X] .. $grid_max->[X]-$size+1) {
    my $l;
    for my $i (0..$size-1) {
      for my $j (0..$size-1) {
        $l += level($x+$i, $y+$j, $serial);
      }
    }
    if (!defined $max || $max < $l) {
      $max = $l;
      $max_id = "$x,$y";
      #print STDERR "\n! $max $max_id\n"
    }
  }
}
#print STDERR "\n";
print "$max\n";
#print STDERR "$max_id\n";

sub level {
  my ($x, $y, $serial) = @_;
  my $r = $x + 10;
  my $p = $r * $y;
  $p += $serial;
  $p *= $r;
  my ($h) = ($p =~ /(.)..$/);
  return $h - 5;
}
