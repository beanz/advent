#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use List::Priority;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_dense_map;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m = ( lines => $in );
  for my $i (0..(@$in-1)) {
    my $l = $in->[0];
    print "$i: $l\n";
  }
  return \%m;
}

use constant
  {
   #X => 0,
   #Y => 1,
   RISK => 2,
   #PATH => 3,
  };

my @DIRS = ([0,-1],[0,1],[1,0],[-1,0]);

sub risk {
  my ($in, $x, $y) = @_;
  my $v = $in->get($x%($in->width), $y%($in->height));
  $v += int($x/$in->width);
  $v += int($y/$in->height);
  while ($v > 9) {
    $v -= 9;
  }
  return $v;
}

sub calc {
  my ($in, $dim) = @_;
  $dim //= 1;
  my $w = $dim*$in->width();
  my $h = $dim*$in->height();
  #dd([$in],[qw/in/]);
  my $search = List::Priority->new();
  $search->insert(0, [0,0,0]);
  my %visited;
  while (my $cur = $search->shift()) {
    if (defined $visited{$cur->[X],$cur->[Y]} &&
        $visited{$cur->[X],$cur->[Y]} <= $cur->[RISK]) {
      next;
    }
    $visited{$cur->[X],$cur->[Y]} = $cur->[RISK];
    for my $off (@DIRS) {
      my $x = $cur->[X] + $off->[X];
      my $y = $cur->[Y] + $off->[Y];
      if ($x < 0 || $y < 0 || $x >= $w || $y >= $h) {
        next;
      }
      my $r = risk($in, $x, $y);
      my $risk = $cur->[RISK] + $r;
      if ($x == $w-1 && $y == $h-1) {
        return $risk;
      }
      $search->insert($risk, [$x, $y, $risk]);
    }
  }
  return -1;
}

sub calc2 {
  return calc($_[0], 5);
}

testCalc() if (TEST);
#print calc($i, 3), "\n"; exit;
print "Part 1: ", calc($i, 1), "\n";

print "Part 2: ", calc($i2, 5), "\n";

sub testCalc {
  my @test_cases =
    (
     [ "test1.txt", 1, 40 ],
     [ "test1.txt", 2, 101 ],
     [ "test1.txt", 3, 170 ],
     [ "test1.txt", 4, 248 ],
     [ "test1.txt", 5, 315 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 1 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 1, 15 ],
     [ "test1.txt", 2, 12 ],
     [ "test1.txt", 10, 37 ],
     [ "test1.txt", 100, 2208 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 2 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}
