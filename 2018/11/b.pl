#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use constant { X => 0, Y => 1 };

my $serial = <>;
chomp $serial;
my $size = <>;
my ($size_min, $size_max) = split /\s+/, $size;
my $grid_min = <>;
$grid_min = [ split /\s+/, $grid_min ];
my $grid_max = <>;
$grid_max = [ split /\s+/, $grid_max ];

my $max;
my $max_id;
my %p;
for my $y ($grid_min->[Y]..$grid_max->[Y]+$size_min) {
  for my $x ($grid_min->[X]..$grid_max->[X]+$size_min) {
    $p{$x}->{$y} = level($x, $y, $serial);
  }
}

#printf STDERR "%d <= y <= %d\n", $grid_min->[Y], $grid_max->[Y]-$size_min+1;
#printf STDERR "%d <= x <= %d\n", $grid_min->[X], $grid_max->[X]-$size_min+1;
for my $y ($grid_min->[Y] .. $grid_max->[Y]-$size_min+1) {
  #print STDERR "$y\r";
  for my $x ($grid_min->[X] .. $grid_max->[X]-$size_min+1) {
    #print STDERR "$x,$y   \r";
    my $l;
    for my $size (1..$size_max) {
      last if ($x + $size-1 > $grid_max->[X] || $y + $size-1 > $grid_max->[Y]);
      #print STDERR "$x,$y $size\n";
      my @sq = ((map [$x + $size-1, $y + $_], 0 .. $size - 1),
                (map [$x + $_, $y + $size -1], 0 .. $size - 2));
      for my $sq (@sq) {
        $l += $p{$sq->[0]}->{$sq->[1]};
        #printf STDERR "L: %d,%d = %d\n", $sq->[0], $sq->[1], $l;
      }
      if ($size >= $size_min && (!defined $max || $max < $l)) {
        $max = $l;
        $max_id = "$x,$y,$size";
        #print STDERR "\n! $max $max_id\n"
      }
    }
  }
}
#print STDERR "\n";
print "$max_id $max\n";

sub level {
  my ($x, $y, $serial) = @_;
  my $r = $x + 10;
  my $p = $r * $y;
  $p += $serial;
  $p *= $r;
  my ($h) = ($p =~ /(.)..$/);
  return $h - 5;
}
