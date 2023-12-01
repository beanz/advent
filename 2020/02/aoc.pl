#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

+my $file = shift // "input.txt";
+my $i = read_lists($file, undef, qr/[- :] ?/);

sub calc {
  my ($i, $part) = @_;
  $part //= 1;
  my $c = 0;
  for my $r (@$i) {
    my ($min, $max, $ch, $pw) = @$r;
    $pw = join '', sort split //, $pw;
    my $mp = $max+1;
    if ($pw =~ /${ch}{$min}/ && $pw !~ /${ch}{$mp}/) {
      $c++ ;
    }
  }
  return $c;
}

if (TEST) {
  my @test_cases =
    (
     [ 'test1.txt', 2 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lists($tc->[0], undef, qr/[- :] ?/));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i, $part) = @_;
  $part //= 1;
  my $c = 0;
  for my $r (@$i) {
    my ($p1, $p2, $ch, $pw) = @$r;
    $p1--; $p2--;
    if ($pw =~ /^.{$p1}${ch}/ xor $pw =~ /^.{$p2}${ch}/) {
      $c++;
    }
  }
  return $c;
}

if (TEST) {
  my @test_cases =
    (
     [ 'test1.txt', 1 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lists($tc->[0], undef, qr/[- :] ?/));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}

$i = read_lists($file, undef, qr/[- :] ?/); # reset input
print "Part 2: ", calc2($i), "\n";
