#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Math::Prime::Util qw/factor/;
use Algorithm::Combinatorics qw/combinations/;

my $i = read_lines(shift//"input.txt")->[0];

sub num_presents {
  my ($house, $partB) = @_;
  my @factors = (1, factor($house));
  my %elves;
  for my $k (1..@factors) {
    my $iter = combinations(\@factors, $k);
    while (my $c = $iter->next) {
      my $p = product(@$c);
      next unless (!$partB || $house/$p <= 50);
      $elves{product(@$c)}++;
    }
  }
  my $sum = sum(keys %elves) // 0;
  return $sum*($partB ? 11 : 10);
}

if (TEST) {
  my @test_input = split/\n/, <<'EOF';
House 1 got 10 presents.
House 2 got 30 presents.
House 3 got 40 presents.
House 4 got 70 presents.
House 5 got 60 presents.
House 6 got 120 presents.
House 7 got 80 presents.
House 8 got 150 presents.
House 9 got 130 presents.
EOF
  chomp @test_input;
  for my $test (@test_input) {
    my ($h, $p) = ($test =~ /House (\d+) got (\d+)/);
    my $res = num_presents($h);
    assertEq("Test num presents house=$h", $res, $p);
  }
  my $res = calc(150);
  assertEq('Test calc(150)', $res, 8);
}

sub calc {
  my ($presents) = @_;
  my $h = 0;
  while (++$h) {
    print STDERR "$h\r" if ( ($h % 10000) == 0 );
    my $n = num_presents($h);
    return $h if ($n >= $presents);
  }
  return -1;
}

print "Part 1: ", calc($i), "\n";

if (TEST) {
  my @test_input = split/\n/, <<'EOF';
House 1 got 11 presents.
House 2 got 33 presents.
House 3 got 44 presents.
House 4 got 77 presents.
House 5 got 66 presents.
House 6 got 132 presents.
House 7 got 88 presents.
House 8 got 165 presents.
House 9 got 143 presents.
EOF
  chomp @test_input;
  for my $test (@test_input) {
    my ($h, $p) = ($test =~ /House (\d+) got (\d+)/);
    my $res = num_presents($h, 1);
    assertEq("Test num presents house=$h part2", $res, $p);
  }
  my $res = calc2(150);
  assertEq('Test calc2(150)', $res, 8);
}

sub calc2 {
  my ($i) = @_;
  my ($presents) = @_;
  my $h = 0;
  while (++$h) {
    print STDERR "$h\r" if ( ($h % 10000) == 0 );
    my $n = num_presents($h, 1);
    return $h if ($n >= $presents);
  }
  return -1;
}

print "Part 2: ", calc2($i), "\n";
