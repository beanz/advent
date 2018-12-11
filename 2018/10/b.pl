#!/usr/bin/perl
use warnings;
use strict;
use v5.10;

use constant { X => 0, Y => 1, VX => 2, VY => 3 };

my @p;
while (<>) {
  unless (/position=<\s*([-\d]+),\s*([-\d]+)> velocity=<\s*([-\d]+),\s*([-\d]+)>/) {
    die "Invalid line: $_\n";
  }
  my $r = [$1, $2, $3, $4];
  push @p, $r;
}

sub exists_s {
  exists $_[0]->{$_[1]} && exists $_[0]->{$_[1]}->{$_[2]}
}

sub pp {
  my ($c, $min, $max, $overlap, $t) = @_;
  for my $y ($min->[Y] .. $max->[Y]) {
    for my $x ($min->[X] .. $max->[X]) {
      print (exists_s($c, $y, $x) ? '#' : '.');
    }
    print "\n";
  }
  print "Overlap: ", ($overlap ? 'yes' : 'no'), "\n";
  print "Time: $t\n";
}

sub get_state {
  state %s;
  my ($points, $t) = @_;
  return $s{$t} if (exists $s{$t});
  if ($t == -1) {print STDERR scalar keys %s, "\n"; }
  my %c = ();
  my @min;
  my @max;
  my $overlap;
  for my $p (@$points) {
    my $x = $p->[X] + ($p->[VX]*$t);
    my $y = $p->[Y] + ($p->[VY]*$t);
    #    print "@$p => $x,$y\n";
    if (exists $c{$y}->{$x}) {
      $overlap++;
    }
    $c{$y}->{$x}++;
    $min[X] = $x if (!defined $min[X] || $min[X] > $x);
    $min[Y] = $y if (!defined $min[Y] || $min[Y] > $y);
    $max[X] = $x if (!defined $max[X] || $max[X] < $x);
    $max[Y] = $y if (!defined $max[Y] || $max[Y] < $y);
  }
  return $s{$t} = [\%c, \@min, \@max, $overlap];
}

sub size {
  my ($min, $max) = @_;
  return ($max->[Y] - $min->[Y])**2 + ($max->[X] - $min->[X])**2;
}

sub growing {
  my ($p, $t) = @_;
  my ($c, $min, $max, $overlap) = @{get_state($p, $t)};
  my ($c1, $min1, $max1, $overlap1) = @{get_state($p, $t+1)};

  return size($min, $max) < size($min1, $max1);
}

my $t = 1;
# find upper bound
while (1) {
  #print STDERR print "$t\n";
  if (growing(\@p, $t)) {
    last;
  }
  $t = $t*2;
}
my $lower = 0;
my $upper = $t;
do {
  $t = int(($upper + $lower)/2);
  #print STDERR "$lower < $t < $upper\n";
  if (growing(\@p, $t)) {
    $upper = $t;
  } else {
    $lower = $t;
  }
} while (($upper-$lower) > 3);

#print STDERR "$lower < $t < $upper\n";
my $best_state;
my $min_size;
for $t ($lower .. $upper) {
  my ($c, $min, $max, $overlap) = @{get_state(\@p, $t)};
  if (!$overlap) {
    #pp($c, $min, $max, $overlap, $t);
    $best_state = [$c, $min, $max, $overlap, $t];
    last;
  }
  my $size = size($min, $max);
  if (!defined $min_size || $size < $min_size) {
    $min_size = $size;
    $best_state = [$c, $min, $max, $overlap, $t];
  }
}
pp(@$best_state);
#get_state([], -1);
