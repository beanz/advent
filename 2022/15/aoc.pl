#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

use constant {
  BX => 2,
  BY => 3,
  MD => 4,
  R1X => 5,
  R1Y => 6,
  R2X => 7,
  R2Y => 8,
};

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @s;
  my $mx = 9999999;
  my $Mx = -9999999;
  my %b;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my ($sx, $sy, $bx, $by) = ($l =~ m!(-?\d+)!g);
    my $md = manhattanDistance([$sx, $sy], [$bx, $by]);
    if ($mx > ($sx - $md)) {
      $mx = $sx - $md;
    }
    if ($Mx < ($sx + $md)) {
      $Mx = $sx + $md;
    }

    #print "$i: $sx,$sy  $bx,$by $md\n";
    my ($r1x, $r1y) = rot_ccw($sx - $md - 1, $sy);
    my ($r2x, $r2y) = rot_ccw($sx + $md + 1, $sy);
    push @s, [$sx, $sy, $bx, $by, $md, $r1x, $r1y, $r2x, $r2y];
    $b{$bx, $by}++;
  }
  my ($y, $max) = @s < 15 ? (10, 20) : (2000000, 4000000);
  return {b => \%b, s => \@s, mx => $mx, Mx => $Mx, y => $y, max => $max};
}

sub calc {
  my ($in) = @_;
  my $y = $in->{y};

  #dd([$in],[qw/in/]);
  my $mx = $in->{mx};
  my $Mx = $in->{Mx};
  my $b = $in->{b};
  my $c = 0;
  my %m;
  my %v;
  for my $r (@{$in->{s}}) {
    my ($sx, $sy, $bx, $by, $md) = @$r;
    for my $inc (-1, 1) {
      my $dy = abs($sy - $y);
      my $x = $sx;
      while ($dy <= $md) {
        $v{$x, $y}++ unless ($b->{$x, $y});
        $x += $inc;
        $dy++;
      }
    }
  }
  return scalar keys %v;
}

sub md {manhattanDistance(@_)}

sub ring {
  my ($sx, $sy, $md, $M) = @_;
  my @r;
  my ($x, $y) = (0, $md + 1);
  my $add = sub {
    my ($x, $y) = @_;
    push @r, [$x, $y] if ($x >= 0 && $x <= $M && $y >= 0 && $y <= $M);
  };
  do {
    $add->($sx + $x, $sy + $y);
    $add->($sx + $x, $sy - $y) if ($y != 0);
    $add->($sx - $x, $sy + $y) if ($x != 0);
    $add->($sx - $x, $sy - $y) if ($y != 0 && $x != 0);
    $x++;
    $y--;
  } while ($y >= 0);
  return @r;
}

sub rot_ccw {
  my ($x, $y) = @_;
  return ($x + $y, $y - $x);
}

sub rot_cw {
  my ($x, $y) = @_;
  return (($x - $y) >> 1, ($x + $y) >> 1);
}

sub calc2 {
  my ($in) = @_;
  my %nx;
  my %ny;
  for my $j (0 .. @{$in->{s}} - 1) {
    for my $k ($j + 1 .. @{$in->{s}} - 1) {
      $nx{$in->{s}->[$j]->[R1X]}++
        if ($in->{s}->[$j]->[R1X] == $in->{s}->[$k]->[R2X]);
      $nx{$in->{s}->[$j]->[R2X]}++
        if ($in->{s}->[$j]->[R2X] == $in->{s}->[$k]->[R1X]);
      $ny{$in->{s}->[$j]->[R1Y]}++
        if ($in->{s}->[$j]->[R1Y] == $in->{s}->[$k]->[R2Y]);
      $ny{$in->{s}->[$j]->[R2Y]}++
        if ($in->{s}->[$j]->[R2Y] == $in->{s}->[$k]->[R1Y]);
    }
  }

  my @poss;
  for my $nx (keys %nx) {
    for my $ny (keys %ny) {
      my ($x, $y) = rot_cw($nx, $ny);
      if (0 <= $x && $x <= $in->{max} && 0 <= $y && $y <= $in->{max}) {
        push @poss, [$x, $y];
      }
    }
  }
  return $poss[0]->[X] * 4000000 + $poss[0]->[Y] if (@poss == 1);
  for my $p (@poss) {
    my ($x, $y) = @$p;
    next
      unless (0 <= $x && $x <= $in->{max} && 0 <= $y && $y <= $in->{max});
    my $near;
    for my $s (@{$in->{s}}) {
      if (md([$s->[X], $s->[Y]], $p) <= $s->[MD]) {
        $near++;
        last;
      }
    }
    if (!$near) {
      return $p->[X] * 4000000 + $p->[Y];
    }

  }
  return -1;
}

sub calc2a {
  my ($in) = @_;
  for my $s (sort {$a->[Y] <=> $b->[Y]} @{$in->{s}}) {
    print "@$s\n";
    my @r = ring($s->[X], $s->[Y], $s->[MD], $in->{max});
    for my $r (@r) {
      next
        if ($r->[X] < 0
        || $r->[Y] < 0
        || $r->[X] > $in->{max}
        || $r->[Y] > $in->{max});
      my $near;
      for my $s2 (@{$in->{s}}) {
        my ($sx, $sy, $j, $j2, $md) = @$s2;
        if (md([$sx, $sy], $r) <= $md) {
          $near++;
          last;
        }
      }
      if (!$near) {
        return $r->[0] * 4000000 + $r->[1];
      }
    }
  }
  return -1;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 26], ["input.txt", 4985193],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test1.txt", 56000011], ["input.txt", 11583882601918],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
