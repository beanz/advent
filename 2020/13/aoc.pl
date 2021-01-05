#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);

my $i2 = read_lines($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

sub calc {
  my ($in) = @_;
  my $dt = $in->[0];
  my $min = 999999;
  my $mbus = undef;
  for my $t (split /,/, $in->[1]) {
    next if ($t eq 'x');
    print $t, "\n" if DEBUG;
    my $m = $t-($dt%$t);
    if ($m < $min) {
      $min = $m;
      $mbus = $t;
    }
    print $m, "\n" if DEBUG;
  }
  return $mbus * $min;
}

use ntheory qw/chinese/;

sub calc2o {
  my ($in) = @_;
  my $min = 9999999999999;
  my @t = split /,/, $in->[1];
  my @p = ();
  for my $i (0..$#t) {
    next if ($t[$i] eq 'x');
    printf "Adding pair %d and %d\n", $t[$i]-$i, $t[$i] if DEBUG;
    push @p, [$t[$i]-$i, $t[$i]];
  }
  return chinese(@p);
}

sub calc2 {
  my ($in) = @_;
  my @t = split /,/, $in->[1];
  my $period = shift @t;
  my $t = 0;
  my $offset;
  for my $i (1..@t) {
    my $bus = $t[$i-1];
    next if ($bus eq 'x');
    $offset = undef;
    while (1) {
      print "$bus $i $t ", ($offset // "undef"), "\n" if DEBUG;
      if (($t + $i) % $bus == 0) {
        if (!defined $offset) {
          $offset = $t;
        } else {
          $period = $t - $offset;
          last;
        }
      }
      $t += $period;
    }
  }
  return $offset
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 295 ],
     [ "test2.txt", 130 ],
     [ "test3.txt", 295 ],
     [ "test4.txt", 295 ],
     [ "test5.txt", 295 ],
     [ "test6.txt", 47 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 1068781 ],
     [ "test2.txt", 3417 ],
     [ "test3.txt", 754018 ],
     [ "test4.txt", 779210 ],
     [ "test5.txt", 1261476 ],
     [ "test6.txt", 1202161486 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
