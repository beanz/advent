#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant {
  V => {
        '>' => [1,0],
        '<' => [-1,0],
        '^' => [0,-1],
        'v' => [0,1],
       },
};

sub houses {
  my $i = shift;
  my %h = ( "0,0" => 1 );
  my ($x, $y) = (0,0);
  for my $d (split//,$i) {
    $x += V->{$d}->[X];
    $y += V->{$d}->[Y];
    $h{$x.','.$y}++;
  }
  return ~~keys %h;
}

if (TEST) {
  my @tests =
    (
     [">", 2],
     ["^>v<", 4],
     ["^v^v^v^v^v", 2],
    );
  for my $tc (@tests) {
    assertEq("houses('$tc->[0]')", houses($tc->[0]), $tc->[1]);
  }
}

sub robo_houses {
  my $i = shift;
  my %h = ( "0,0" => 1 );
  my ($xs, $ys) = (0,0);
  my ($xr, $yr) = (0,0);
  for my $pair (pairs split//,$i) {
    my ($ds, $dr) = @$pair;
    $xs += V->{$ds}->[X];
    $ys += V->{$ds}->[Y];
    $h{$xs.','.$ys}++;
    $xr += V->{$dr}->[X];
    $yr += V->{$dr}->[Y];
    $h{$xr.','.$yr}++;
  }
  return scalar keys %h;
}

if (TEST) {
  my @tests =
    (
     ["^v", 3],
     ["^>v<", 3],
     ["^v^v^v^v^v", 11],
    );
  for my $tc (@tests) {
    assertEq("robo_houses('$tc->[0]')", robo_houses($tc->[0]), $tc->[1]);
  }
}

my $i = read_lines(shift//"input.txt")->[0];
print "Part 1: ", houses($i), "\n";
print "Part 2: ", robo_houses($i), "\n";
