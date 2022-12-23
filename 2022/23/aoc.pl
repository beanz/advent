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
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m = (m => {}, ri => 0, bb => [],);
  for my $i (0 .. (@$in - 1)) {
    my @l = split //, $in->[$i];
    for my $j (0 .. @l - 1) {
      if ($l[$j] eq '#') {
        minmax_xy($m{bb}, $j, $i);
        $m{m}->{$j, $i}++;
      }
    }
  }
  return \%m;
}

my @checks = (
  sub {
    my ($in, $x, $y) = @_;
    return [0, -1]
      if (!exists $in->{m}->{$x - 1, $y - 1}
      && !exists $in->{m}->{$x, $y - 1}
      && !exists $in->{m}->{$x + 1, $y - 1});
  },
  sub {
    my ($in, $x, $y) = @_;
    return [0, 1]
      if (!exists $in->{m}->{$x - 1, $y + 1}
      && !exists $in->{m}->{$x, $y + 1}
      && !exists $in->{m}->{$x + 1, $y + 1});
  },
  sub {
    my ($in, $x, $y) = @_;
    return [-1, 0]
      if (!exists $in->{m}->{$x - 1, $y - 1}
      && !exists $in->{m}->{$x - 1, $y}
      && !exists $in->{m}->{$x - 1, $y + 1});
  },
  sub {
    my ($in, $x, $y) = @_;
    return [1, 0]
      if (!exists $in->{m}->{$x + 1, $y - 1}
      && !exists $in->{m}->{$x + 1, $y}
      && !exists $in->{m}->{$x + 1, $y + 1});
  },
);

sub none {
  my ($in, $x, $y) = @_;
  return if (exists $in->{m}->{$x - 1, $y - 1});
  return if (exists $in->{m}->{$x, $y - 1});
  return if (exists $in->{m}->{$x + 1, $y - 1});
  return if (exists $in->{m}->{$x - 1, $y});
  return if (exists $in->{m}->{$x + 1, $y});
  return if (exists $in->{m}->{$x - 1, $y + 1});
  return if (exists $in->{m}->{$x, $y + 1});
  return if (exists $in->{m}->{$x + 1, $y + 1});
  return 1;
}

sub iter {
  my ($in) = @_;
  my %p;
  my %c;
  for my $k (keys %{$in->{m}}) {
    my ($x, $y) = split /,/, $k;
    next if (none($in, $x, $y));
    for my $i (0 .. 3) {
      my $off = $checks[($i + $in->{ri}) % 4]->($in, $x, $y);
      next unless ($off);
      my ($ix, $iy) = @$off;
      my ($nx, $ny) = ($x + $ix, $y + $iy);
      $c{$nx, $ny}++;
      $p{$x, $y} = [$nx, $ny];
      last;
    }
  }
  my %n;
  my $bb = [];
  my $moved = 0;
  for my $k (keys %{$in->{m}}) {
    my ($x, $y) = split /,/, $k;
    unless ($p{$x, $y}) {
      $n{$x, $y}++;
      minmax_xy($bb, $x, $y);
      next;
    }
    my ($nx, $ny) = @{$p{$x, $y}};
    if ($c{$nx, $ny} > 1) {
      $n{$x, $y}++;
      minmax_xy($bb, $x, $y);
      next;
    }
    $n{$nx, $ny}++;
    minmax_xy($bb, $nx, $ny);
    $moved++;
  }
  $in->{m} = \%n;
  $in->{bb} = $bb;
  $in->{ri}++;
  $in->{ri} = 0 if ($in->{ri} == @checks);
  return $moved;
}

sub pp {
  my ($in) = @_;
  for my $y ($in->{bb}->[MINY] .. $in->{bb}->[MAXY]) {
    for my $x ($in->{bb}->[MINX] .. $in->{bb}->[MAXX]) {
      print exists $in->{m}->{$x, $y} ? '#' : '.';
    }
    print "\n";
  }
  print "\n";
}

sub count {
  my ($in) = @_;
  my $c = 0;
  for my $y ($in->{bb}->[MINY] .. $in->{bb}->[MAXY]) {
    for my $x ($in->{bb}->[MINX] .. $in->{bb}->[MAXX]) {
      $c++ unless (exists $in->{m}->{$x, $y});
    }
  }
  return $c;
}

sub calc {
  my ($in) = @_;
  my $p1 = -1;
  for my $r (1 .. 10000) {
    my $moved = iter($in);
    $p1 = count($in) if ($r == 10);
    return [$p1, $r] unless ($moved);
  }
  return [$p1, -2];
}

testParts() if (TEST);

my $res = calc($i);
print "Part 1: ", $res->[0], "\n";
print "Part 2: ", $res->[1], "\n";

sub testParts {
  my @test_cases =
    (["test0.txt", -1, 4], ["test1.txt", 110, 20], ["input.txt", 3923, 1019],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
