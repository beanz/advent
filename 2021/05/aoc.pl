#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_vents;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_vents {
  my ($file) = @_;
  my $in = read_lines($file);
  my @r;
  for my $l (@$in) {
    my @n = split /(?:,| -> )/, $l;
    push @r, {x1 => $n[0], y1 => $n[1], x2 => $n[2], y2 => $n[3] };
  }
  return \@r;
}

sub pp {
  my ($bb, $m) = @_;
  for my $y ($bb->[MINY] .. $bb->[MAXY]) {
    for my $x ($bb->[MINX] .. $bb->[MAXX]) {
      print $m->{$x,$y}//".";
    }
    print "\n";
  }
}
sub calc {
  my ($in) = @_;
  my %m1;
  my %m2;
  my $c1;
  my $c2;
  my @bb;
  for my $v (@$in) {
    print "$v->{x1}, $v->{y1} -> $v->{x2}, $v->{y2}\n" if DEBUG;
    if ($v->{x1} == $v->{x2}) {
      my $x = $v->{x1};
      for my $y (min($v->{y1},$v->{y2}) .. max($v->{y1},$v->{y2})) {
        minmax_xy(\@bb, $x, $y);
        $m1{$x, $y}++;
        if ($m1{$x, $y} == 2) {
          $c1++;
        }
        $m2{$x, $y}++;
        if ($m2{$x, $y} == 2) {
          $c2++;
        }
      }
    } else {
      my $x1 = $v->{x1};
      my $y1 = $v->{y1};
      my $x2 = $v->{x2};
      my $y2 = $v->{y2};
      if ($x1 > $x2) {
        my $tx = $x1;
        my $ty = $y1;
        $x1 = $x2;
        $y1 = $y2;
        $x2 = $tx;
        $y2 = $ty;
      }
      my $d = $y1 == $y2 ? 0 : $y1 > $y2 ? -1 : 1;
      my $y = $y1;
      for my $x ($x1 .. $x2) {
        minmax_xy(\@bb, $x, $y);
        if ($d == 0) {
          $m1{$x, $y}++;
          if ($m1{$x, $y} == 2) {
            $c1++;
          }
        }
        $m2{$x, $y}++;
        if ($m2{$x, $y} == 2) {
          $c2++;
        }
        $y += $d;
      }
    }
  }
  if (DEBUG) {
    pp(\@bb, \%m1);
    print "\n";
    pp(\@bb, \%m2);
    print "$c1, $c2\n";
  }
  return [$c1,$c2];
}

testCalc() if (TEST);

my ($p1, $p2) = @{calc($i)};
print "Part 1: $p1\n";
print "Part 2: $p2\n";

sub testCalc {
  my @test_cases =
    (
     [ "test1.txt", 5, 12 ],
     [ "input.txt", 6005, 23864 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
