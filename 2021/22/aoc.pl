#!/usr/bin/perl
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
#my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

{
  package Cuboid;
  use List::Util qw/min max/;
  use constant
    {
     VAL => 0,
     XMIN => 1,
     XMAX => 2,
     YMIN => 3,
     YMAX => 4,
     ZMIN => 5,
     ZMAX => 6,
    };
  sub new {
    my ($pkg, @p) = @_;
    bless \@p, $pkg;
  }
  sub pp {
    ($_[0]->[VAL] ? 'on' : 'off')." ".
      $_[0]->[XMIN]."..".$_[0]->[XMAX].",".
      $_[0]->[YMIN]."..".$_[0]->[YMAX].",".
      $_[0]->[ZMIN]."..".$_[0]->[ZMAX];
  }
  sub volume {
    ($_[0]->[XMAX] - $_[0]->[XMIN]) *
      ($_[0]->[YMAX] - $_[0]->[YMIN]) *
      ($_[0]->[ZMAX] - $_[0]->[ZMIN]);
  }
  sub value {
    $_[0]->[VAL];
  }
  sub xmin {
    $_[0]->[XMIN]
  }
  sub xmax {
    $_[0]->[XMAX]
  }
  sub ymin {
    $_[0]->[YMIN]
  }
  sub ymax {
    $_[0]->[YMAX]
  }
  sub zmin {
    $_[0]->[ZMIN]
  }
  sub zmax {
    $_[0]->[ZMAX]
  }
  sub contains {
    my ($c0, $c1) = @_;
    $c0->[XMIN] <= $c1->[XMIN] && $c0->[XMAX] >= $c1->[XMAX] &&
      $c0->[YMIN] <= $c1->[YMIN] && $c0->[YMAX] >= $c1->[YMAX] &&
      $c0->[ZMIN] <= $c1->[ZMIN] && $c0->[ZMAX] >= $c1->[ZMAX];
  }
  sub intersects {
    my ($c0, $c1) = @_;
    $c0->[XMIN] <= $c1->[XMAX] && $c0->[XMAX] >= $c1->[XMIN] &&
      $c0->[YMIN] <= $c1->[YMAX] && $c0->[YMAX] >= $c1->[YMIN] &&
      $c0->[ZMIN] <= $c1->[ZMAX] && $c0->[ZMAX] >= $c1->[ZMIN];
  }
  sub diff {
    my ($c0, $c1) = @_;
    if ($c1->contains($c0)) {
      return [];
    }
    if (!$c0->intersects($c1)) {
      return [$c0];
    }
    my @x = $c0->[XMIN];
    push @x, $c1->[XMIN] if ($c0->[XMIN] < $c1->[XMIN] &&
                             $c1->[XMIN] < $c0->[XMAX]);
    push @x, $c1->[XMAX] if ($c0->[XMIN] < $c1->[XMAX] &&
                             $c1->[XMAX] < $c0->[XMAX]);
    push @x, $c0->[XMAX];

    my @y = $c0->[YMIN];
    push @y, $c1->[YMIN] if ($c0->[YMIN] < $c1->[YMIN] &&
                             $c1->[YMIN] < $c0->[YMAX]);
    push @y, $c1->[YMAX] if ($c0->[YMIN] < $c1->[YMAX] &&
                             $c1->[YMAX] < $c0->[YMAX]);
    push @y, $c0->[YMAX];

    my @z = $c0->[ZMIN];
    push @z, $c1->[ZMIN] if ($c0->[ZMIN] < $c1->[ZMIN] &&
                             $c1->[ZMIN] < $c0->[ZMAX]);
    push @z, $c1->[ZMAX] if ($c0->[ZMIN] < $c1->[ZMAX] &&
                             $c1->[ZMAX] < $c0->[ZMAX]);
    push @z, $c0->[ZMAX];

    my @res;
    for my $xi (0..@x-2) {
      for my $yi (0..@y-2) {
        for my $zi (0..@z-2) {
          my $n = Cuboid->new($c0->value,
                              $x[$xi], $x[$xi+1],
                              $y[$yi], $y[$yi+1],
                              $z[$zi], $z[$zi+1]);
          push @res, $n unless ($c1->contains($n));
        }
      }
    }
    return \@res;
  }
}

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @c;
  for my $i (0..(@$in-1)) {
    my $l = $in->[$i];
    my @s = split / /, $l, 2;
    my @v = $s[1] =~ m/(-?\d+)/mg;
    $v[$_]++ for (1,3,5); # set max to max+1 for convinience
    push @c, Cuboid->new( ($s[0] eq 'on' ? 1 : 0), @v );
    #print "$i: $l\n";
  }
  return \@c;
}

sub calc {
  my ($in) = @_;
  #dd([$in],[qw/in/]);
  my %m;
  for my $cuboid (@$in) {
    my $v = $cuboid->value;
    my $zmin = $cuboid->zmin;
    my $zmax = $cuboid->zmax;
    if (($zmin < -50 && $zmax < -50) || ($zmin > 50 && $zmax > 50)) {
      #print "z out of range $zmin - $zmax\n";
      next;
    }
    my $ymin = $cuboid->ymin;
    my $ymax = $cuboid->ymax;
    if (($ymin < -50 && $ymax < -50) || ($ymin > 50 && $ymax > 50)) {
      #print "y out of range $ymin - $ymax\n";
      next;
    }
    my $xmin = $cuboid->xmin;
    my $xmax = $cuboid->xmax;
    if (($xmin < -50 && $xmax < -50) || ($xmin > 50 && $xmax > 50)) {
      #print "x out of range $xmin - $xmax\n";
      next;
    }
    $zmin = max($zmin, -50);
    $zmax = min($zmax, 51);
    $ymin = max($ymin, -50);
    $ymax = min($ymax, 51);
    $xmin = max($xmin, -50);
    $xmax = min($xmax, 51);
    #print "@$c => $xmin..$xmax $ymin..$ymax  $zmin..$zmax\n";

    for my $z ($zmin .. $zmax-1) {
      for my $y ($ymin .. $ymax-1) {
        for my $x ($xmin .. $xmax-1) {
          if ($v) {
            $m{$x,$y,$z} = 1;
          } else {
            delete $m{$x,$y,$z};
          }
        }
      }
    }
  }
  return scalar keys %m;
}

sub calc2 {
  my ($in) = @_;
  my @cuboids;
  for my $cuboid (@$in) {
    #print "processing ", $cuboid->pp, "\n";
    my @n;
    for my $old (@cuboids) {
      push @n, @{$old->diff($cuboid)};
    }
    push @n, $cuboid if ($cuboid->value);
    #for my $n (@n) {
    #  print "  ", $n->pp, "\n";
    #}
    @cuboids = @n;
  }
  my $vol = 0;
  for my $cuboid (@cuboids) {
    $vol += $cuboid->volume();
  }
  return $vol;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 39 ],
     [ "test2.txt", 590784 ],
     [ "input.txt", 598616 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 39 ],
     [ "test2.txt", 39769202357779 ],
     [ "test3.txt", 2758514936282235 ],
     [ "input.txt", 1193043154475246 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
