#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use List::Util qw/sum/;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
};

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

print nice('ugknbfddgicrmopn'), " = 1\n";
print nice('aaa'), " = 1\n";
print nice('jchzalrnumimnmhp'), " = 0\n";
print nice('haegwjzuvuyypxyu'), " = 0\n";
print nice('dvszwmarrgswjxmb'), " = 0\n";

sub nice2 {
  my ($i) = @_;
  my $pair = ($i =~ m/(..).*\1/);
  print "  $pair pair twice\n" if DEBUG;
  my $repeat = ($i =~ m/(.).\1/);
  print "  $repeat repeat\n" if DEBUG;
  return $pair && $repeat ? '1' : 0;
}

print nice2('qjhvhtzxzqqjkmpb'), " = 1\n";
print nice2('xxyxx'), " = 1\n";
print nice2('uurcxstgmygtbstg'), " = 0\n";
print nice2('ieodomkazucvgmuy'), " = 0\n";

my @i = <>;
chomp @i;
my $sum = sum(map { nice($_) } @i);
print "Part 1: ", $sum, "\n";
$sum = sum(map { nice2($_) } @i);
print "Part 2: ", $sum, "\n";
