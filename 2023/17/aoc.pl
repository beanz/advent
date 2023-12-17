#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
use POE::XS::Queue::Array;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @m = map {[split //, $_]} @$in;
  my %d = (g => \@m, w => ~~ @{$m[0]}, h => ~~ @m);
  return \%d;
}
use constant {
  D => 2,
  L => 3,
};

sub calc {
  my ($in) = @_;
  return [solve($in, 0, 3), solve($in, 4, 10)];
}

sub solve {
  my ($in, $minS, $maxS) = @_;
  my $todo = POE::XS::Queue::Array->new();
  if ($minS == 0) {
    $todo->enqueue(0, [0, 0, [1, 0], 0]);
  }
  my %seen;
  my $add = sub {
    my ($x, $y, $dir, $l) = @_;
    for my $s (1 .. $maxS) {
      $x += $dir->[X];
      $y += $dir->[Y];
      if ($x < 0 || $x >= $in->{w} || $y < 0 || $y >= $in->{h}) {
        return;
      }
      $l += $in->{g}->[$y]->[$x];
      if ($s < $minS) {
        next;
      }
      $todo->enqueue($l, [$x, $y, $dir, $l]);
    }
  };
  $add->(0, 0, [1, 0], 0);
  while (1) {
    my ($pri, $qid, $cur) = $todo->dequeue_next();
    die "search failed" unless (defined $pri);
    my ($x, $y, $dir, $l) = @$cur;

    if ($x == $in->{w} - 1 && $y == $in->{h} - 1) {
      return $l;
    }

    if (exists $seen{"$x,$y,@$dir"}) {
      next;
    }
    $seen{"$x,$y,@$dir"}++;
    my $t = {
      "1,0" => [[0, -1], [0, 1]],
      "-1,0" => [[0, -1], [0, 1]],
      "0,1" => [[-1, 0], [1, 0]],
      "0,-1" => [[-1, 0], [1, 0]],
    }->{"@$dir"};
    $add->($x, $y, $_, $l) for (@$t);
  }
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
