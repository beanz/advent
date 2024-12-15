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

#my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_chunks($file);
  chomp($in->[1]);
  $in->[1] =~ s/\n//g;
  my $in2 = $in->[0];
  $in2 =~ s/#/##/g;
  $in2 =~ s/\./../g;
  $in2 =~ s/@/@./g;
  $in2 =~ s/O/[]/g;
  return [read_map($in->[0]), read_map($in2), [split //, $in->[1]]];
}

sub read_map {
  my ($mm) = @_;
  my $m = DenseMap->from_lines([split /\n/, $mm]);
  my $s;
  $m->visit_xy(
    sub {
      my ($m, $x, $y, $ch) = @_;
      $s = [$x, $y] if ($ch eq '@');
    }
  );
  $m->set(@$s, '.');
  return [$m, $s];
}

sub offsets {
  {'^' => [0, -1], '>' => [1, 0], 'v' => [0, 1], '<' => [-1, 0]}->{$_[0]};
}

sub pp {
  my ($m, $s) = @_;
  for my $y (0 .. $m->height - 1) {
    for my $x (0 .. $m->width - 1) {
      my $ch = $s->{$x, $y};
      $ch = $m->get($x, $y) unless (defined $ch);
      print STDERR $ch;
    }
    print STDERR "\n";
  }
}

sub score {
  my ($m) = @_;
  my $sc = 0;
  for my $y (0 .. $m->height - 1) {
    for my $x (0 .. $m->width - 1) {
      my $ch = $m->get($x, $y);
      if ($ch eq 'O' || $ch eq '[') {
        $sc += $y * 100 + $x;
      }
    }
  }
  return $sc;
}

sub calc {
  my ($in) = @_;
  my ($in1, $in2, $moves) = @$in;
  my ($map, $start) = @$in1;
  my $p1 = robot($map, $moves, $start);
  my ($map2, $start2) = @$in2;
  my $p2 = robot($map2, $moves, $start2, 1);
  return [$p1, $p2];
}

sub robot {
  my ($map, $moves, $start, $p2) = @_;
  my ($x, $y) = @$start;
  for my $m (@$moves) {
    print STDERR "$m\n" if DEBUG;
    pp($map, {"$x,$y" => '@'}) if DEBUG;
    my ($dx, $dy) = @{offsets($m)};
    my ($nx, $ny) = ($x + $dx, $y + $dy);
    if ($map->get($nx, $ny) eq '#') {
      next;
    }
    if ($map->get($nx, $ny) eq '.') {
      ($x, $y) = ($nx, $ny);
      next;
    }
    my $move;
    my @boxes;
    if ($p2 && $dx == 0) {
      my @check = [$x, $y];
      while (1) {
        my $free = 1;
        my $wall;
        for my $c (@check) {
          if ($map->get($c->[X] + $dx, $c->[Y] + $dy) eq '#') {
            $wall++;
          }
          if ($map->get($c->[X] + $dx, $c->[Y] + $dy) ne '.') {
            undef $free;
          }
        }
        if ($free) {
          $move = 1;
          last;
        }
        if ($wall) {
          last;
        }
        my %s;
        my @next_check;
        for my $c (@check) {
          my ($cx, $cy) = ($c->[X] + $dx, $c->[Y] + $dy);
          my $ch = $map->get($cx, $cy);
          if ($ch eq '[' && !$s{$cx, $y}) {
            $s{$cx, $cy}++;
            push @next_check, [$cx, $cy];
            push @boxes, [$cx, $cy, $ch];
            $cx++;
            $s{$cx, $cy}++;
            push @next_check, [$cx, $cy];
            push @boxes, [$cx, $cy, ']'];
          } elsif ($ch eq ']') {
            $s{$cx, $cy}++;
            push @next_check, [$cx, $cy];
            push @boxes, [$cx, $cy, $ch];
            $cx--;
            $s{$cx, $cy}++;
            push @next_check, [$cx, $cy];
            push @boxes, [$cx, $cy, '['];
          }
        }
        @check = @next_check;
      }
    } else {
      my ($tx, $ty) = ($nx, $ny);
      while (1) {
        my $ch = $map->get($tx, $ty);
        if ($ch eq '#') {
          undef $move;
          last;
        }
        $move++;
        if ($ch eq '.') {
          last;
        }
        push @boxes, [$tx, $ty, $ch];
        ($tx, $ty) = ($tx + $dx, $ty + $dy);
      }
    }
    next unless ($move);
    for my $box (@boxes) {
      $map->set($box->[X], $box->[Y], '.');
    }
    for my $box (@boxes) {
      print STDERR "M: $box->[X],$box->[Y] $box->[2]\n" if DEBUG;
      $map->set($box->[X] + $dx, $box->[Y] + $dy, $box->[2]);
    }
    ($x, $y) = ($nx, $ny);
  }
  pp($map, {"$x,$y" => '@'}) if DEBUG;
  return score($map);
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
