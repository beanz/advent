#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use List::Util qw/min product pairs/;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
  V => {
        '>' => [1,0],
        '<' => [-1,0],
        '^' => [0,-1],
        'v' => [0,1],
       },
  X => 0,
  Y => 1,
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
  return \%h;
}

print ~~keys%{houses(">")}, " = 2\n";
print ~~keys%{houses("^>v<")}, " = 4\n";
print ~~keys%{houses("^v^v^v^v^v")}, " = 2\n";


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
  return \%h;
}

print ~~keys%{robo_houses("^v")}, " = 3\n";
print ~~keys%{robo_houses("^>v<")}, " = 3\n";
print ~~keys%{robo_houses("^v^v^v^v^v")}, " = 11\n";

my $i = <>;
chomp $i;
print "Part 1: ", ~~keys%{houses($i)}, "\n";
print "Part 2: ", ~~keys%{robo_houses($i)}, "\n";
