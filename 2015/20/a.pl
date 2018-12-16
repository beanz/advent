#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use Math::Prime::Util qw/factor/;
use Algorithm::Combinatorics qw/combinations/;
use List::Util qw/uniqnum min max minstr maxstr sum product pairs/;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant
  {
   DEBUG => $ENV{AoC_DEBUG},
   TEST => $ENV{AoC_TEST},
   X => 0,
   Y => 1,
  };

my $i = <>;
chomp $i;

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
    print "Test num presents house=$h: $res == $p\n";
    die "failed\n" unless ($res == $p);
  }
  my $res = calc(150);
  print "Test calc(150): $res == 8\n";
  die "failed\n" unless ($res == 8);
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
    print "Test num presents house=$h: $res == $p\n";
    die "failed\n" unless ($res == $p);
  }
  my $res = calc2(150);
  print "Test calc2(150): $res == 8\n";
  die "failed\n" unless ($res == 8);
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
