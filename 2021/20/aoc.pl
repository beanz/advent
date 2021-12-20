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

sub read_stuff {
  my $file = shift;
  my $in = read_chunks($file);
  my %m = ( m => {}, l => [], bb => [], def => 0 );
  my $l = $in->[0];
  $l =~ s/\n//g;
  $m{l} = [split //, $l];
  #print scalar @{$m{l}}, "\n";
  my $m = [split /\n/, $in->[1]];
  for my $y (0..(@$m-1)) {
    my $l = $m->[$y];
    $l = [ split//, $m->[$y] ];
    for my $x (0..(@$l-1)) {
      next unless ($l->[$x] eq '#');
      $m{m}->{$x,$y} = 1;
      minmax_xy($m{bb}, $x, $y);
    }
  }
  return \%m;
}

sub pp {
  my ($m) = @_;
  for my $y ($m->{bb}->[MINY]..$m->{bb}->[MAXY]) {
    for my $x ($m->{bb}->[MINX]..$m->{bb}->[MAXX]) {
      print(exists $m->{m}->{$x,$y} ? '#' : '.');
    }
    print "\n";
  }
}

sub val {
  my ($m, $x, $y) = @_;
  if ($x < $m->{bb}->[MINX] || $x > $m->{bb}->[MAXX] ||
      $y < $m->{bb}->[MINY] || $y > $m->{bb}->[MAXY]) {
    return $m->{def};
  }
  return exists $m->{m}->{$x, $y} ? 1 : 0;
}

#print val($i, 2, 2),"\n";

sub bin {
  my ($m, $x, $y) = @_;
  my $n = 0;
  for my $o ([-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]) {
    $n = ($n << 1) + val($m, $x+$o->[X], $y+$o->[Y]);
  }
  return $n;
}

#print bin($i, 2, 2),"\n";

sub lookup {
  my ($m, $x, $y) = @_;
  return $m->{l}->[bin($m, $x, $y)];
}

#print lookup($i, 2, 2),"\n";

sub iter {
  my ($m) = @_;
  my %n;
  my $bb = [];
  my $c = 0;
  for my $y ($m->{bb}->[MINY]-1..$m->{bb}->[MAXY]+1) {
    for my $x ($m->{bb}->[MINX]-1..$m->{bb}->[MAXX]+1) {
      my $v = lookup($m, $x, $y);
      #print "$x,$y: $v\n";
      if ($v eq '#') {
        $c++;
        $n{$x,$y} = '#';
        minmax_xy($bb, $x, $y);
      }
    }
  }
  $m->{m} = \%n;
  $m->{bb} = $bb;
  return $c;
}

# $i->{def} = 0;
# print iter($i), "\n"; pp($i);
# $i->{def} = 1;
# print iter($i), "\n"; pp($i); exit;

sub calc {
  my ($m, $n) = @_;
  $n //= 2;
  my $c = 0;
  #pp($m);
  for my $i (0..$n-1) {
    $m->{def} = $i%2;
    $c = iter($m);
    #pp($m);
  }
  return $c;
}

testCalc() if (TEST);

print "Part 1: ", calc($i), "\n";
print "Part 2: ", calc($i2, 50), "\n";

sub testCalc {
  my @test_cases =
    (
     [ "test1.txt", 31, 5132 ],
     [ "input.txt", 5486, 20210 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
    $res = calc($reader->($tc->[0]), 50);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[2]);
  }
}
