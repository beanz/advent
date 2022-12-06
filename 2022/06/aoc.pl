#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use List::MoreUtils qw/slideatatime distinct/;
#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_guess;
my $i = $reader->($file);

sub calc {
  my ($in, $l) = @_;
  $l //= 4;
  my $i = 0;
  my $line = ref $in ? $in->[0] : $in;
  my $it = slideatatime 1, $l, split//, $line;
  while (my @a = $it->()) {
    return $i+$l if ((distinct @a) == @a);
    $i++;
  }
  die "not found";
}

testParts() if (TEST);

print "Part 1: ", calc($i), "\n";
print "Part 2: ", calc($i, 14), "\n";

sub testParts {
  my @test_cases =
    (
     [ "test1.txt", 4, 7 ],
     [ "test1.txt", 14, 19 ],
     [ "input.txt", 4, 1282 ],
     [ "input.txt", 14, 3513 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 1 [$tc->[0] $tc->[1]]", $res, $tc->[2]);
  }
}
