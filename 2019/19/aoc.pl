#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use IntCode;

$|=1;
my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub draw {
  my ($D) = @_;
  my $s = "";
  my $bot = '^';
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      $s .= $D->{m}->{hk($x,$y)} ? '#' : '.';
    }
    $s .= "\n";
  }
  return $s;
}

sub in_beam {
  my ($prog, $x, $y) = @_;
  my $ic = IntCode->new($prog, [$x, $y]);
  while (!$ic->{done}) {
    $ic->run();
    if (@{$ic->{o}} == 1) {
      return $ic->{o}->[0] == 1;
    }
  }
}

sub part1 {
  my ($prog, $max) = @_;
  my $D =
    {
     bb => [],
     m => {},
    };
  minmax_xy($D->{bb}, 0,0);
  minmax_xy($D->{bb}, $max, $max,2);
  my $count = 0;
  my $first;
  my $last;
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    undef $first;
    undef $last;
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      if (in_beam($prog, $x, $y)) {
        if (!defined $first) {
          $first = $x;
        }
        $last = $x;
        $D->{m}->{hk($x,$y)} = '#';
        $count++;
      }
    }
  }
  print draw($D) if DEBUG;
  return $count, $first, $last;
}

sub find_ratios {
  my ($prog, $y) = @_;
  my $first = 49;
  while (!in_beam($prog, $first, $y)) {
    $first++;
  }
  my $last = $first;
  while (in_beam($prog, $last, $y)) {
    $last++;
  }
  return ($first, $last);
}

my ($count, $first, $last) = part1($i, 49);
print "Part 1: $count\n";
if (!defined $first) {
  ($first, $last) = find_ratios($i, 49);
}

my $r1 = $first / 49;
my $r2 = $last / 49;

sub square_fits {
  my ($prog, $x, $y) = @_;

  if (in_beam($prog, $x, $y) &&
      in_beam($prog, $x+99, $y) &&
      in_beam($prog, $x, $y+99) &&
      in_beam($prog, $x+99, $y+99)) {
    return 1;
  }
  return undef;
}

sub square_fits_y {
  my ($prog, $y, $r1, $r2) = @_;
  my $min = int($y*$r1);
  my $max = int($y*$r2);
  for my $x ($min .. $max) {
    return $x if (square_fits($i, $x, $y));
  }
  return;
}

$i = parse_input(\@i);
my $upper = 64;
while (!square_fits_y($i, $upper, $r1, $r2)) {
  $upper *= 2;
  print "... $upper\n" if DEBUG;
}

my $lower = $upper / 2;
print "$lower .. $upper\n" if DEBUG;

while (1) {
  my $mid = int(($upper-$lower)/2) + $lower;
  last if ($mid == $lower);
  if (square_fits_y($i, $mid, $r1, $r2)) {
    $upper = $mid;
  } else {
    $lower = $mid;
  }
  print "  new $lower .. $upper\n" if DEBUG;
}
print "Close lower y: $lower\n" if DEBUG;

for my $y ($lower..$lower+5) {
  my $x = square_fits_y($i, $y, $r1, $r2);
  if ($x) {
    print "Part 2: ", $x*10000 + $y, "\n";
    last;
  }
}

