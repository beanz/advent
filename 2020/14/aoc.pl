#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);
my $i2 = read_lines($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

sub calc {
  my ($in) = @_;
  my %mem;
  my $mask0;
  my $mask1;
  for my $l (@$in) {
    if ($l =~ /^mask = ([X01]{36})$/) {
      print "New mask ", $1, "\n" if DEBUG;
      $mask0 = 0;
      $mask1 = 0;
      for my $bit (split //, $1) {
        $mask0 <<= 1;
        $mask1 <<= 1;
        unless ($bit eq '0') {
          $mask0++;
        }
        if ($bit eq '1') {
          $mask1++;
        }
      }
      next;
    }
    my ($a, $v) = ($l =~ /mem\[(\d+)] = (\d+)/);
    my $b = sprintf "%036b", $v;
    if (DEBUG) {
      print "M[$a] = $v\n";
      print "value:  $b ($v)\n";
      printf "mask0: %036b\n", $mask0;
      printf "mask1: %036b\n", $mask1;
    }
    $v |= $mask1;
    $v &= $mask0;
    print "result: $b ($v)\n" if DEBUG;
    $mem{$a} = $v;
    dd([\%mem]) if DEBUG;
    print "\n" if DEBUG;
  }
  my $c = 0;
  for my $v (values %mem) {
    $c += $v;
  }
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my %mem;
  my $maskx;
  my $mask1;
  for my $l (@$in) {
    if ($l =~ /^mask = ([X01]{36})$/) {
      print "New mask ", $1, "\n" if DEBUG;
      my $mask = $1;
      $maskx = 0;
      $mask1 = 0;
      for my $i (0.. length($mask) - 1) {
        my $bit = substr $mask, $i, 1;
        $mask1 <<= 1;
        $maskx <<= 1;
        if ($bit eq '1') {
          $mask1++;
        } elsif ($bit eq 'X') {
          $maskx++;
        }
      }
      next;
    }
    my ($a, $v) = ($l =~ /mem\[(\d+)] = (\d+)/);
    if (DEBUG) {
      printf "M[%d %b] = %d\n", $a, $a, $v;
      printf "mask1: %036b\n", $mask1;
      printf "maskx: %036b\n", $maskx;
    }
    $a |= $mask1;
    my @addrs = $a;
    for (my $m = (1<<35); $m >= 1; $m >>= 1) {
      next if (($m&$maskx) == 0);
      for my $i (0..$#addrs) {
        if (($addrs[$i]&$m) != 0) { # have a 1 bit so append 0 bit case
          push @addrs, ($addrs[$i] & (0xfffffffff^$m));
        } else { # have a 0 bit so append 1 bit case
          push @addrs, ($addrs[$i] | $m);
        }
      }
    }
    for my $a (@addrs) {
      $mem{$a} = $v;
      if (DEBUG) {
        printf "M[%d %b] = %d\n", $a, $a, $v;
      }
    }
    dd([\%mem]) if DEBUG;
    print "\n" if DEBUG;
  }
  my $c = 0;
  for my $v (values %mem) {
    $c += $v;
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

if ($file eq 'test1.txt') {
  print "Part 2: takes ages\n";
  exit;
}
print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 165 ],
     [ "test2.txt", 51 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test2.txt", 208 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
