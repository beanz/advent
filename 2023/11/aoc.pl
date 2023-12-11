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

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @m = map {[split //]} @$in;
  return \@m;
}

sub calc {
  my ($in, $ex) = @_;
  $ex //= 1000000;
  my $h = @$in;
  my $w = @{$in->[0]};
  my %c;
  for my $y (0 .. $h - 1) {
    $c{Y}->{$y} = 1;
    for my $x (0 .. $w - 1) {
      if ($in->[$y]->[$x] ne '.') {
        $c{Y}->{$y} = 0;
        last;
      }
    }
  }
  for my $x (0 .. $w - 1) {
    $c{X}->{$x} = 1;
    for my $y (0 .. $h - 1) {
      if ($in->[$y]->[$x] ne '.') {
        $c{X}->{$x} = 0;
        last;
      }
    }
  }
  return [solve($in, \%c), solve($in, \%c, $ex)];
}

sub solve {
  my ($in, $gc, $ex) = @_;
  $ex //= 2;
  $ex--;
  my $h = @$in;
  my $w = @{$in->[0]};
  my ($ax, $ay) = (0, 0);
  my @g;
  for my $y (0 .. $h - 1) {
    for my $x (0 .. $w - 1) {
      if ($in->[$y]->[$x] ne '.') {
        push @g, [$ax, $ay];
      }
      $ax += 1+$ex*$gc->{X}->{$x};
    }
    $ax = 0;
    $ay += 1+$ex*$gc->{Y}->{$y};
  }
  my $s = 0;
  for my $i (0 .. @g - 1) {
    for my $j (($i + 1) .. @g - 1) {
      my $md = manhattanDistance($g[$i], $g[$j]);
      $s += $md;
    }
  }
  return $s;
}

testParts() if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;

sub testParts {
  open my $fh, "TC.txt" || die "no test case file: $@\n";
  my $c;
  { local $/; $c = <$fh>; }
  chomp $c;
  my @tc;
  for (split /\n---END---\n/, $c) {
    my ($args, $p1, $p2) = split/\n/;
    my @a = split/\s+/, $args;
    my $f = shift @a;
    my $in = $reader->($f);
    my $res = calc($in, @a);
    assertEq("Test 1 [$f @a]", $res->[0], $p1);
    assertEq("Test 2 [$f @a]", $res->[1], $p2);
  }
}
