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

#my $reader = \&read_stuff;
my $reader = \&read_guess;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m = (lines => $in);
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    print "$i: $l\n";
  }
  return \%m;
}

my %snafu = (
  "1" => 1,
  "2" => 2,
  "0" => 0,
  "-" => -1,
  "=" => -2,
);

my @rsnafu = (["0", 0], ["1", 0], ["2", 0], ["=", 2], ["-", 1],);

sub d2s {
  my ($n) = @_;
  return "" if ($n == 0);
  my $r = $rsnafu[$n % 5];
  return $r->[0] . d2s(int(($n + $r->[1]) / 5));
}

sub calc {
  my ($in) = @_;
  my $c = 0;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my $n = 0;
    for my $d (split //, $l) {
      $n = 5 * $n + $snafu{$d};
    }
    $c += $n;
  }
  return ~~ reverse d2s($c);
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

sub testPart1 {
  my @test_cases =
    (["test1.txt", "2=-1=0"], ["input.txt", "122-12==0-01=00-0=02"],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}
