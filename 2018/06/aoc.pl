#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my @i2 = @{[@i]};

my @p;
my $bound = sqrt(shift @i);
for (@i) {
  push @p, [split /, /];
}

sub md {
  my ($p1, $p2) = @_;
  return abs($p1->[X]-$p2->[X]) + abs($p1->[Y]-$p2->[Y]);
}

sub k {
  return $_[X].'!'.$_[Y];
}

sub closest {
  my ($g, $x, $y) = @_;

  my $k = k($x,$y);
  my @c = sort { $g->{$k}->{$a} <=> $g->{$k}->{$b} } keys %{$g->{$k}};
  if (@c == 1) {
    return $c[0];
  } elsif (@c && $g->{$k}->{$c[0]} < $g->{$k}->{$c[1]}) {
    return $c[0];
  } else {
    return
  }
}

sub grid {
  my ($d) = @_;
  my %g;
  my $min;
  my $max;
  for my $i (0..$#p) {
    my $p = $p[$i];
    for my $ox (-$d..$d) {
      for my $oy (-$d..$d) {
        my $x = $p->[X]+$ox;
        my $y = $p->[Y]+$oy;
        $g{k($x,$y)}->{$i} = md([$x,$y],$p);
        if (!exists $min->[X] || $min->[X] > $x) {
          $min->[X] = $x;
        }
        if (!exists $max->[X] || $max->[X] < $x) {
          $max->[X] = $x;
        }
        if (!exists $min->[Y] || $min->[Y] > $y) {
          $min->[Y] = $y;
        }
        if (!exists $max->[Y] || $max->[Y] < $y) {
          $max->[Y] = $y;
        }
      }
    }
  }

  my @a;
  for my $y ($min->[Y]..$max->[Y]) {
    for my $x ($min->[X]..$max->[X]) {
      my $c = closest(\%g, $x, $y);
      $a[$c]++ if (defined $c);
      #print $c // '.';
    }
    #print "\n";
  }
  return \@a;
}

my $a1 = grid($bound);
my $a2 = grid($bound+1);

my $max;
for my $i (0..$#p) {
  if ($a1->[$i] == $a2->[$i]) {
    if (!defined $max || $a1->[$i] > $max) {
      $max = $a1->[$i];
    }
  }
}
print 'Part 1: ', $max, "\n";

my $d = shift @i2;
@p = ();
my @min;
my @max;
for (@i2) {
  my ($x, $y) = split /, /;
  push @p, [$x, $y];
  if (!defined $min[X] || $min[X] > $x) {
    $min[X] = $x;
  }
  if (!defined $max[X] || $max[X] < $x) {
    $max[X] = $x;
  }
  if (!defined $min[Y] || $min[Y] > $y) {
    $min[Y] = $y;
  }
  if (!defined $max[Y] || $max[Y] < $y) {
    $max[Y] = $y;
  }
}

sub sd {
  my ($x, $y, $d) = @_;
  my $s = 0;
  for my $p (@p) {
    $s += md([$x,$y], $p);
  }
  return $s;
}

$b = sqrt $d;
my $a;
for my $y ($min[Y]-$b .. $max[Y]+$b) {
 LOOP:
  for my $x ($min[X]-$b .. $max[X]+$b) {
    my $in = sd($x, $y) < $d;
    $a++ if ($in);
  }
}
print 'Part 2: ', $a, "\n";
