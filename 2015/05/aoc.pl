#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $vowel = 'aeiou';
my $good = join '|', map { $_.$_ } 'a' .. 'z';
my $bad = 'ab|cd|pq|xy';

print STDERR "Good: ", $good, "\n" if DEBUG;
print STDERR "Bad: ", $bad, "\n" if DEBUG;

sub nice {
  my ($i) = @_;
  print $i, "\n" if DEBUG;
  my $vowels = ($i =~ s/([$vowel])/$1/g);
  print "  $vowels vowels\n" if DEBUG;
  my $good = ($i =~ /$good/o);
  print "  $good good\n" if DEBUG;
  my $bad = ($i =~ /$bad/o);
  print "  $bad bad\n" if DEBUG;
  return $vowels >= 3 && $good && !$bad ? 1 : '0';
}

if (TEST) {
  my @tests =
    (
     ['ugknbfddgicrmopn', 1],
     ['aaa', 1],
     ['jchzalrnumimnmhp', 0],
     ['haegwjzuvuyypxyu', 0],
     ['dvszwmarrgswjxmb', 0],
    );
  for my $tc (@tests) {
    assertEq("nice('$tc->[0]')", nice($tc->[0]), $tc->[1]);
  }
}

sub nice2 {
  my ($i) = @_;
  my $pair = ($i =~ m/(..).*\1/);
  print "  $pair pair twice\n" if DEBUG;
  my $repeat = ($i =~ m/(.).\1/);
  print "  $repeat repeat\n" if DEBUG;
  return $pair && $repeat ? '1' : 0;
}

if (TEST) {
  my @tests =
    (
     ['qjhvhtzxzqqjkmpb', 1],
     ['xxyxx', 1],
     ['uurcxstgmygtbstg', 0],
     ['ieodomkazucvgmuy', 0],
    );
  for my $tc (@tests) {
    assertEq("nice2('$tc->[0]')", nice2($tc->[0]), $tc->[1]);
  }
}

my @i = @{read_lines(shift//"input.txt")};
my $sum = sum(map { nice($_) } @i);
print "Part 1: ", $sum, "\n";
$sum = sum(map { nice2($_) } @i);
print "Part 2: ", $sum, "\n";
