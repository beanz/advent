#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

sub lfloor {
  my $i = shift;
  return ($i =~ y/\(//) - ($i =~ y/\)//);
}

sub basement {
  my $d = shift;
  $d =~ s/[^\(\)]//g; # clean
  my @i = split //, $d;
  my $f = 0;
  for my $i (1..@i) {
    $f += $i[$i-1] eq '(' ? 1 : -1;
    #print "$d\[$i]: $f\n";
    if ($f == -1) {
      return $i
    }
  }
  return -1;
}

if (TEST) {
  my @tests =
    (
     ["(())", 0],
     ["()()", 0],
     ["(((", 3],
     ["(()(()(", 3],
     ["))(((((", 3],
     ["())", -1],
     ["))(", -1],
     [")))", -3],
     [")())())", -3],
    );
  for my $tc (@tests) {
    assertEq("Test 1 [$tc->[0]]", lfloor($tc->[0]), $tc->[1]);
  }

  @tests =
    (
     [")", 1],
     ["()())", 5],
    );

  for my $tc (@tests) {
    assertEq("Test 2 [$tc->[0]]", basement($tc->[0]), $tc->[1]);
  }
}

my $i = <>;
chomp $i;
print "Part 1: ", lfloor($i), "\n";
print "Part 2: ", basement($i), "\n";
