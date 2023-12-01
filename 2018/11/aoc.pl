#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant { VX => 2, VY => 3 };

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

if (@i == 1) {
  push @i, "1 300", "1 1", "300 300";
}
{
  my $serial = $i[0];
  my $size = 3;
  $size =~ s/\s+.*//;
  my $grid_min = $i[2];
  $grid_min = [ split /\s+/, $grid_min ];
  my $grid_max = $i[3];
  $grid_max = [ split /\s+/, $grid_max ];

  my $max;
  my $max_id;
  my %p;
  for my $y ($grid_min->[Y] .. $grid_max->[Y]-$size+1) {
    print STDERR "$y\r" if DEBUG;
    for my $x ($grid_min->[X] .. $grid_max->[X]-$size+1) {
      my $l;
      for my $i (0..$size-1) {
        for my $j (0..$size-1) {
          $l += level1($x+$i, $y+$j, $serial);
        }
      }
      if (!defined $max || $max < $l) {
        $max = $l;
        $max_id = "$x,$y";
        print STDERR "\n! $max $max_id\n" if DEBUG;
      }
    }
  }
  print STDERR "\n" if DEBUG;
  print 'Part 1: ', $max_id, "\n";

  sub level1 {
    my ($x, $y, $serial) = @_;
    my $r = $x + 10;
    my $p = $r * $y;
    $p += $serial;
    $p *= $r;
    my ($h) = ($p =~ /(.)..$/);
    return $h - 5;
  }
}

my $serial = $i[0];
my $size = $i[1];
my ($size_min, $size_max) = split /\s+/, $size;
$size =~ s/\s+.*//;
my $grid_min = $i[2];
$grid_min = [ split /\s+/, $grid_min ];
my $grid_max = $i[3];
$grid_max = [ split /\s+/, $grid_max ];

my $max;
my $max_id;
my %sat;
for my $y (1..$grid_max->[Y]) {
  for my $x (1..$grid_max->[X]) {
    my $l = level($x, $y, $serial);
    $sat{$x}->{$y} = $l;
    if ($x > 1) {
      $sat{$x}->{$y} += $sat{$x-1}->{$y};
      if ($y > 1) {
        $sat{$x}->{$y} -= $sat{$x-1}->{$y-1};
      }
    }
    if ($y > 1) {
      $sat{$x}->{$y} += $sat{$x}->{$y-1};
    }
    #printf STDERR "%3d/%3d ", $l, $sat{$x}->{$y};
  }
  #print STDERR "\n";
}

#printf STDERR "%d <= y <= %d\n", $grid_min->[Y], $grid_max->[Y]-$size_min+1;
#printf STDERR "%d <= x <= %d\n", $grid_min->[X], $grid_max->[X]-$size_min+1;
for my $size ($size_min..$size_max) {
  for my $y ($grid_min->[Y] .. $grid_max->[Y]-$size+1) {

    #print STDERR "$y\r";
    for my $x ($grid_min->[X] .. $grid_max->[X]-$size+1) {
      printf STDERR "%3d, %3d %3d\r", $x, $y, $size if DEBUG;
      last if ($x + $size-1 > $grid_max->[X] || $y + $size-1 > $grid_max->[Y]);
      my $l = level_square($x, $y, $size);
      if (!defined $max || $max < $l) {
        $max = $l;
        $max_id = "$x,$y,$size";
        print STDERR "\n! $max $max_id\n" if DEBUG;
      }
    }
  }
}
print STDERR "\n" if DEBUG;
print 'Part 2: ', $max_id, "\n";

sub key {
  join ':', @_
}

sub level_square {
  my ($x, $y, $size) = @_;
  my $s = $sat{$x+$size-1}->{$y+$size-1};
  if ($x > 1) {
    $s -= $sat{$x-1}->{$y+$size-1};
    if ($y > 1) {
      $s += $sat{$x-1}->{$y-1};
    }
  }
  if ($y > 1) {
    $s -= $sat{$x+$size-1}->{$y-1};
  }
  return $s;
}

sub level {
  my ($x, $y, $serial) = @_;
  my $r = $x + 10;
  my $p = $r * $y;
  $p += $serial;
  $p *= $r;
  my ($h) = ($p =~ /(.)..$/);
  return $h - 5;
}

