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
my $reader = \&read_lines;
my $i = $reader->($file);

sub calc {
  my ($in) = @_;
  my $c = 0;
  my %s = ();
  my $p = "/";
  for my $l (@$in) {
    if ($l =~ /^. cd (.*)$/) {
      if ($1 eq "/") {
        $p = $1;
      } elsif ($1 eq "..") {
        $p =~ s![^/]+/$!!;
      } else {
        $p .= "$1/";
      }
      next;
    } elsif ($l =~ /^(\w+) dir/) {
      next;
    }
    if ($l =~ /^(\d+)/) {
      my $b = $1;
      my $d = $p;
      while ($d ne "") {
      $s{$d} += $b;
        $d =~ s![^/]*/$!!;
      } 
    }
  }
  my $min = 2**32;
  my $total = $s{"/"};
  my $need = 30000000-(70000000-$total);
  for (keys %s) {
    my $v = $s{$_};
    if ($v <= 100000) {
      $c+=$v;
    }
    if ($v >= $need && $v < $min) {
      $min = $v;
    }
  }
  return [$c, $min];
}

testParts() if (TEST);

my $r = calc($i);
print "Part 1: ", $r->[0], "\n";
print "Part 2: ", $r->[1], "\n";

sub testParts {
  my @test_cases =
    (
     [ "test1.txt", 95437, 24933642 ],
     [ "input.txt", 1432936, 272298 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 1 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
