#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $i = read_lines($file);
my $i2 = read_lines($file);

sub math {
  my ($sum) = @_;
  while ($sum =~ s/\(([^()]+)\)/math($1)/e ||
         $sum =~ s/^(\d+) \+ (\d+)/$1 + $2/e ||
         $sum =~ s/^(\d+) \* (\d+)/$1 * $2/e) {
    return $sum unless ($sum =~ /\D/);
  }
}

sub math2 {
  my ($sum) = @_;
  print "S: ", $sum, "\n" if DEBUG;
  while ($sum =~ s/\(([^()]+)\)/math2($1)/e ||
         $sum =~ s/(\d+) \+ (\d+)/$1 + $2/e ||
         $sum =~ s/^(\d+) \* (\d+)/$1 * $2/e) {
    return $sum unless ($sum =~ /\D/);
  }
}

sub calc {
  my ($in) = @_;
  my $t = 0;
  $t += math($_) for (@$in);
  return $t;
}

sub calc2 {
  my ($in) = @_;
  my $t = 0;
  $t += math2($_) for (@$in);
  return $t;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "1 + 2 * 3 + 4 * 5 + 6", 71 ],
     [ "1 + (2 * 3) + (4 * (5 + 6))", 51 ],
     [ "2 * 3 + (4 * 5)", 26 ],
     [ "5 + (8 * 3 + 9 + 3 * 4 * 3)", 437 ],
     [ "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 12240 ],
     [ "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632 ],
    );
  for my $tc (@test_cases) {
    my $res = math($tc->[0]);
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "8 * 3 + 9 + 3 * 4 * 3", 1440 ],
     [ "1 + 2 * 3 + 4 * 5 + 6", 231 ],
     [ "1 + (2 * 3) + (4 * (5 + 6))", 51 ],
     [ "2 * 3 + (4 * 5)", 46 ],
     [ "5 + (8 * 3 + 9 + 3 * 4 * 3)", 1445 ],
     [ "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 669060 ],
     [ "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 23340 ],
    );
  for my $tc (@test_cases) {
    my $res = math2($tc->[0]);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
