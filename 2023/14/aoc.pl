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

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @m = map {[split //]} @$in;
  return \@m;
}

sub load {
  my ($in) = @_;
  my $load = 0;
  my $w = @{$in->[0]};
  my $h = @{$in};
  for my $x (0 .. $w - 1) {
    my $s = $h;
    for my $y (0 .. $h - 1) {
      my $ch = $in->[$y]->[$x];
      if ($ch eq 'O') {
        $load += $s;
        $s--;
      } elsif ($ch eq '#') {
        $s = $h - $y - 1;
      }
    }
  }
  return $load;
}

sub pp {
  my ($in) = @_;
  for my $l (@$in) {
    print join '', @{$l}, "\n";
  }
  print "\n";
}

sub load2 {
  my ($in) = @_;
  my $w = @{$in->[0]};
  my $h = @{$in};
  my $load = 0;
  for my $x (0 .. $w - 1) {
    for my $y (0 .. $h - 1) {
      my $ch = $in->[$y]->[$x];
      if ($ch eq 'O') {
        my $sc = $h - $y;
        $load += $sc;
      }
    }
  }
  return $load;
}

sub spin {
  my ($in) = @_;
  my $w = @{$in->[0]};
  my $h = @{$in};

  #pp($in);
  while (1) {
    my $m = 0;
    for my $x (0 .. $w - 1) {
      for my $y (reverse(1 .. $h - 1)) {
        my $ch = $in->[$y]->[$x];
        my $chm = $in->[$y - 1]->[$x];
        if ($ch eq 'O' && $chm eq '.') {
          $in->[$y - 1]->[$x] = $ch;
          $in->[$y]->[$x] = $chm;
          $m++;
        }
      }
    }
    last unless ($m);
  }

  while (1) {
    my $m = 0;
    for my $y (0 .. $h - 1) {
      for my $x (reverse(1 .. $w - 1)) {
        my $ch = $in->[$y]->[$x];
        my $chm = $in->[$y]->[$x - 1];
        if ($ch eq 'O' && $chm eq '.') {
          $in->[$y]->[$x - 1] = $ch;
          $in->[$y]->[$x] = $chm;
          $m++;
        }
      }
    }
    last unless ($m);
  }

  while (1) {
    my $m = 0;
    for my $x (0 .. $w - 1) {
      for my $y (0 .. $h - 2) {
        my $ch = $in->[$y]->[$x];
        my $chm = $in->[$y + 1]->[$x];
        if ($ch eq 'O' && $chm eq '.') {
          $in->[$y + 1]->[$x] = $ch;
          $in->[$y]->[$x] = $chm;
          $m++;
        }
      }
    }
    last unless ($m);
  }

  while (1) {
    my $m = 0;
    for my $y (0 .. $h - 1) {
      for my $x (0 .. $w - 2) {
        my $ch = $in->[$y]->[$x];
        my $chm = $in->[$y]->[$x + 1];
        if ($ch eq 'O' && $chm eq '.') {
          $in->[$y]->[$x + 1] = $ch;
          $in->[$y]->[$x] = $chm;
          $m++;
        }
      }
    }
    last unless ($m);
  }

  return load2($in);
}

sub calc {
  my ($in) = @_;
  my $tar = 1000000000;
  my $p1 = load($in);
  my $p2 = 0;
  my %seen;
  my $c = 0;
  my $cycle;
  while ($c < $tar) {
    $c++;
    $p2 = spin($in);
    next if ($cycle);
    my $k = join '!', map {join '', @$_} @$in;
    if (exists $seen{$k}) {
      my $l = $c - $seen{$k};
      my $jump = int(($tar - $c) / $l);
      #print "cycle $l $jump ", $jump*$l, "\n";
      $c += $jump * $l;
    }
    $seen{$k} = $c;
  }
  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
