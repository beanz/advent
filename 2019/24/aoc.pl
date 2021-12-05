#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

sub parse_input {
  my ($lines) = @_;
  my $m = join '', @$lines;
  my $n = 0;
  my $i = 0;
  while ($i < length($m)) {
    my $p = index $m, '#', $i;
    last if ($p == -1);
    $n += 2**$p;
    $i = $p+1;
  }
  return [$n, length($lines->[0]), ~~@$lines];
}

sub bug {
  my ($p, $x, $y) = @_;
  return 0 if ($y < 0 || $y >= $p->[2] || $x < 0 || $x >= $p->[1]);
  my $a = $y*$p->[1] + $x;
  #print "bug: $x $y = $a\n";
  return ($p->[0] & 2**($y*$p->[1] + $x));
}

sub life {
  my ($p, $x, $y) = @_;
  my $c = 0;
  $c++ if (bug($p, $x, $y-1));
  $c++ if (bug($p, $x-1, $y));
  $c++ if (bug($p, $x+1, $y));
  $c++ if (bug($p, $x, $y+1));
  return $c == 1 || (!bug($p, $x, $y) && $c == 2);
}

sub pp {
  my ($p) = @_;
  my $s = "@$p\n";
  for my $y (0..$p->[2]-1) {
    for my $x (0..$p->[1]-1) {
      $s .= bug($p, $x, $y) ? '#' : '.';
    }
    $s .= "\n";
  }
  return $s;
}

sub calc {
  my ($p) = @_;
  my %seen;
  while (1) {
    #print pp($p),"\n";
    #select undef, undef, undef, 0.5;
    my $new = 0;
    for my $y (0..$p->[2]-1) {
      for my $x (0..$p->[1]-1) {
        my $a = $y*$p->[1] + $x;
        if (life($p, $x, $y)) {
          $new += 2**$a;
        }
      }
    }
    if (exists $seen{$new}) {
      return $new;
    }
    $seen{$new}++;
    $p->[0] = $new;
  }
  return 1;
}

if (TEST) {
  assertEq("Test Example", calc(parse_input(read_lines("test.txt"))), 2129920);
}

my $n = parse_input(\@i);
my $part1 = calc($n);
print "Part 1: ", $part1, "\n";
