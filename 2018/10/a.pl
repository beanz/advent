#!/usr/bin/perl
use warnings;
use strict;

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
  my ($c, $min, $max) = @_;
  for my $y ($min->[Y] .. $max->[Y]) {
    for my $x ($min->[X] .. $max->[X]) {
      print (exists_s($c, $y, $x) ? '#' : '.');
    }
    print "\n";
  }
}

my $t = 0;
while (1) {
  my %c = ();
  my @min;
  my @max;
  print STDERR "$t\r";
  for my $p (@p) {
    my $x = $p->[X] + ($p->[VX]*$t);
    my $y = $p->[Y] + ($p->[VY]*$t);
#    print "@$p => $x,$y\n";
    $c{$y}->{$x}++;
    $min[X] = $x if (!defined $min[X] || $min[X] > $x);
    $min[Y] = $y if (!defined $min[Y] || $min[Y] > $y);
    $max[X] = $x if (!defined $max[X] || $max[X] < $x);
    $max[Y] = $y if (!defined $max[Y] || $max[Y] < $y);
  }
  if (($max[Y] - $min[Y]) < 9) {
    #print STDERR "\n";
    pp(\%c, \@min, \@max);
    last;
  }
  $t++;
}
