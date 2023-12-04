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

my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  my @copies;
  for my $l (@$in) {
    my ($c, $a, $b) = split /[:\|]/, $l;
    my %a = map {$_ => 1} ($a =~ m/\d+/g);
    my $n = 1;
    for (@copies) {
      if ($_ <= 0) {
        next;
      }
      $_--;
      $n++;
    }
    @copies = grep {$_ > 0} @copies;
    print STDERR "N: $n\n" if DEBUG;
    my $p = 0;
    for my $o ($b =~ m/\d+/g) {
      if (exists $a{$o}) {
        $p++;
      }
    }
    $p1 += 2**($p - 1) if ($p);
    $p2 += $n;
    push @copies, $p for (0 .. $n - 1);
  }
  return [$p1, $p2];
}

testParts() if (TEST);

my $r = calc($i);
print "Part 1: ", $r->[0], "\n";
print "Part 2: ", $r->[1], "\n";

sub testParts {
  my @test_cases = (["test1.txt", 13, 30], ["input.txt", 25183, 5667240],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
