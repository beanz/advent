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

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m;
  $m{h} = @$in;
  $m{w} = length $in->[0];
  for my $y (0 .. (@$in - 1)) {
    my $l = [split //, $in->[$y]];
    for my $x (0 .. @$l - 1) {
      my $ch = $l->[$x];
      if ($ch eq '.' && $y == 0) {
        $m{st} = [$x, $y];
      }
      if ($ch eq '.' && $y == $m{h} - 1) {
        $m{en} = [$x, $y];
      }
      if ($ch =~ /^[v^<>]$/) {
        push @{$m{b}->{$x, $y}}, [@{binc($ch)}, $ch];
        $ch = '.';
      }
      $m{m}->{$x, $y} = $ch;
    }
  }
  $m{pos} = $m{st};
  return \%m;
}

sub pp {
  my ($in, $t, $ex) = @_;
  $t //= 0;
  my $bt = $in->{b}->[$t];
  for my $y (0 .. $in->{h} - 1) {
    for my $x (0 .. $in->{w} - 1) {
      if ($ex && $x == $ex->[X] && $y == $ex->[Y]) {
        print "X";
        next;
      }
      my @b = @{$bt->{$x, $y} || []};
      if (@b) {
        if (@b == 1) {
          print $b[0]->[2];
        } else {
          print((~~ @b) % 10);
        }
      } else {
        if ($x == $in->{pos}->[X] && $y == $in->{pos}->[Y]) {
          print "E";
        } else {
          print $in->{m}->{$x, $y};
        }
      }
    }
    print "\n";
  }
}

sub binc {
  my ($b) = @_;
  return {'^' => [0, -1], 'v' => [0, 1], '<' => [-1, 0], '>' => [1, 0]}->{$b};
}

sub calc_bad {
  my ($in, $n) = @_;
  $n //= 1000;
  my @b;
  push @b, dclone($in->{b});
  for my $t (0 .. $n) {
    my %nb;
    for my $k (keys %{$in->{b}}) {
      my ($x, $y) = split /,/, $k;
      for my $b (@{$in->{b}->{$k}}) {
        my ($nx, $ny) = ($x + $b->[X], $y + $b->[Y]);
        if ($nx == 0) {
          $nx = $in->{w} - 2;
        }
        if ($ny == 0) {
          $ny = $in->{h} - 2;
        }
        if ($nx == $in->{w} - 1) {
          $nx = 1;
        }
        if ($ny == $in->{h} - 1) {
          $ny = 1;
        }
        push @{$nb{$nx, $ny}}, $b;
      }
    }
    push @b, dclone(\%nb);
    $in->{b} = \%nb;
  }
  $in->{b} = \@b;
}

sub calc {
  my ($in) = @_;
  calc_bad($in);
  my @todo = ([@{$in->{st}}, 0, 0, 0]);
  my %s;
  my $p1 = 0;
  my $p2 = 0;
  while (@todo) {
    my ($x, $y, $t, $st, $end) = @{shift @todo};

    #pp($in, $t, [$x,$y]); select undef,undef,undef,1;
    if ($y == $in->{h} - 1) {
      if ($end && $st) {
        $p2 = $t;
        last;
      }
      unless ($p1) {
        $p1 = $t;
      }
      $end = 1;
    }
    if ($y == 0 && $end) {
      $st = 1;
    }
    if (exists $s{$x, $y, $t, $st, $end}) {
      next;
    }
    $s{$x, $y, $t, $st, $end}++;
    for my $o ([0, 0], [0, -1], [0, 1], [-1, 0], [1, 0]) {
      my ($nx, $ny) = ($x + $o->[X], $y + $o->[Y]);
      unless (0 <= $nx && $nx < $in->{w} && 0 <= $ny && $ny < $in->{h}) {
        next;
      }
      if ($in->{m}->{$nx, $ny} eq '#') {
        next;
      }
      if (exists $in->{b}->[$t + 1]->{$nx, $ny}) {
        next;
      }
      push @todo, [$nx, $ny, $t + 1, $st, $end];
    }
  }
  return [$p1, $p2];
}

testParts() if (TEST);

my $res = calc($i);
print "Part 1: ", $res->[0], "\n";
print "Part 2: ", $res->[1], "\n";

sub testParts {
  my @test_cases = (["test1.txt", 18, 54], ["input.txt", 314, 896],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
