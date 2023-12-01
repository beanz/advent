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
  my %m;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    die unless ($l =~ m!Valve (\w\w) has flow rate=(\d+); .*valves? (.*)!);
    my ($v, $r, $to) = ($1, $2, [split /, /, $3]);
    $m{$v} = [$r, $to];
  }
  return \%m;
}
use constant {
  RATE => 0,
  NEXT => 1,
  POS => 0,
  TIME => 1,
  PRES => 2,
  OPEN => 3,
};

sub calc {
  my ($in) = @_;
  my $max = 0;
  my @todo = (['AA', 30, 0, {}, 'AA']);
  my %v;
  while (@todo) {
    my $cur = shift @todo;
    my ($pos, $t, $flow, $open, $path) = @$cur;
    my $k = "$pos,$flow";
    next if ($v{$k});
    $v{$k}++;
    if ($max < $flow) {
      $max = $flow;
    }
    if ($t <= 1) {
      next;
    }
    my ($rate, $next) = @{$in->{$pos}};
    if (!exists $open->{$pos} && $rate > 0) {
      my %nopen = %{$open};
      $nopen{$pos}++;
      my $nt = $t - 1;
      push @todo, [$_, $nt - 1, $flow + $rate * $nt, \%nopen, "$path,$_"]
        for (@$next);
    }
    push @todo, [$_, $t - 1, $flow, $open, "$path,$_"] for (@$next);
  }
  return $max;
}

sub calc2 {
  my ($in) = @_;
  my $max = 0;
  my @todo = (['AA', 'AA', 26, 0, {}, 'AA', 'AA']);
  my %v;
  while (@todo) {
    my $cur = shift @todo;
    my ($pos, $pos_e, $t, $flow, $open, $path, $path_e) = @$cur;
    my $k = $pos lt $pos_e ? "$pos,$pos_e,$flow" : "$pos_e,$pos,$flow";
    next if ($v{$k});
    $v{$k}++;
    if ($max < $flow) {
      $max = $flow;
    }
    if ($t <= 1) {
      next;
    }
    my ($rate, $next) = @{$in->{$pos}};
    my ($rate_e, $next_e) = @{$in->{$pos_e}};
    if (!exists $open->{$pos} && $rate > 0) {
      my %nopen = %{$open};
      $nopen{$pos}++;
      my $nt = $t - 1;
      push @todo,
        [$pos, $_, $nt, $flow + $rate * $nt, \%nopen, $path, "$path_e,$_"]
        for (@$next_e);
      if (!exists $open->{$pos_e} && $rate_e > 0) {
        my %nopen2 = %nopen;
        $nopen2{$pos_e}++;
        push @todo,
          [$pos, $pos_e, $nt, $flow + $rate_e * $nt, \%nopen2, $path, $path_e];
      }
    }
    if (!exists $open->{$pos_e} && $rate_e > 0) {
      my %nopen = %{$open};
      $nopen{$pos_e}++;
      my $nt = $t - 1;
      push @todo,
        [$_, $pos_e, $nt, $flow + $rate_e * $nt, \%nopen, "$path,$_", $path_e]
        for (@$next);
    }
    for my $mpos (@$next) {
      for my $epos (@$next_e) {
        push @todo,
          [$mpos, $epos, $t - 1, $flow, $open, "$path,$mpos", "$path_e,$epos"];
      }
    }
  }
  return $max;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 1651], ["input.txt", 1915],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test1.txt", 1707], ["input.txt", 2772],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
