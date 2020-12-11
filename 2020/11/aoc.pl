#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_map($file);
#dd([$i]); exit;
my $i2 = read_map($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

sub read_map {
  my ($file) = @_;
  my $l = read_lines($file);
  my $h = scalar @$l;
  my $w = length $l->[0];
  my %m;
  for my $y (0..$h-1) {
    for my $x (0..$w-1) {
      $m{hk($x,$y)} = substr $l->[$y], $x, 1;
    }
  }
  return { m => \%m, h => $h, w => $w };
}

sub pp {
  my ($m) = @_;
  my $s = "";
  for my $y (0..$m->{h}-1) {
    for my $x (0..$m->{w}-1) {
      $s .= $m->{m}->{hk($x,$y)};
    }
    $s .= "\n";
  }
  return $s;
}

sub count {
  my ($m) = @_;
  my $c = 0;
  for my $y (0..$m->{h}-1) {
    for my $x (0..$m->{w}-1) {
      $c++ if ($m->{m}->{hk($x,$y)} == '#');
    }
  }
  return $c;
}

sub seat {
  my ($m, $x, $y) = @_;
  if ($x < 0 || $x > $m->{w}-1 || $y < 0 || $y > $m->{h}-1) {
    return '.';
  }
  return $m->{m}->{hk($x,$y)};
}

sub calc {
  my ($m) = @_;
  my %s;
  print pp($m) if (DEBUG > 1);
  while (1) {
    my %n;
    my $c;
    for my $y (0..$m->{h}-1) {
      for my $x (0..$m->{w}-1) {
        my $s = seat($m, $x, $y);
        my $n = $s;
        if ($s ne '.') {
          my %c = ('#' => 0, '.' => 0, 'L' => 0);
          for my $o (@{eightNeighbourOffsets([$x, $y])}) {
            $c{seat($m, $x+$o->[X], $y+$o->[Y])}++;
          }
          if ($s eq 'L' && $c{'#'} == 0) {
            $n = '#';
          } elsif ($s eq '#' && $c{'#'} >= 4) {
            $n = 'L';
          }
          $c++ if ($n eq '#');
        }
        $n{hk($x,$y)} = $n;
      }
    }
    $m->{m} = \%n;
    if (DEBUG) {
      print pp($m) if (DEBUG > 1);
      print $c, "\n";
    }
    if ($s{$c}) {
      return $c;
    }
    $s{$c}++;
  }
  return 0;
}

sub neighbourCounts {
  my ($m, $x, $y) = @_;
  my %c = ('#' => 0, '.' => 0, 'L' => 0);
  for my $o (@{eightNeighbourOffsets([$x, $y])}) {
    my $ox = $x+$o->[X];
    my $oy = $y+$o->[Y];
    my $s = '.';
    while ($ox >= 0 && $ox <= $m->{w}-1 && $oy >= 0 && $oy <= $m->{h}-1) {
      $s = seat($m, $ox, $oy);
      if ($s ne '.') {
        last;
      }
      $ox += $o->[X];
      $oy += $o->[Y];
    }
    $c{$s}++;
  }
  return \%c;
}

sub calc2 {
  my ($m) = @_;
  my %s;
  print pp($m) if (DEBUG > 1);
  while (1) {
    my %n;
    my $c;
    for my $y (0..$m->{h}-1) {
      for my $x (0..$m->{w}-1) {
        my $s = seat($m, $x, $y);
        my $n = $s;
        if ($s ne '.') {
          my $cc = neighbourCounts($m, $x, $y);
          if ($s eq 'L' && $cc->{'#'} == 0) {
            $n = '#';
          } elsif ($s eq '#' && $cc->{'#'} >= 5) {
            $n = 'L';
          }
          $c++ if ($n eq '#');
        }
        $n{hk($x,$y)} = $n;
      }
    }
    $m->{m} = \%n;
    if (DEBUG) {
      print pp($m) if (DEBUG > 1);
      print $c, "\n";
    }
    if ($s{$c}) {
      return $c;
    }
    $s{$c}++;
  }
  return 1;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 37 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_map($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 26 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_map($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
