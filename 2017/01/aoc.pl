#!/usr/bin/perl
use strict;
use warnings;
use v5.20;

my $i = <>;
chomp $i;

$_ = $i;
my $c = 0;
$c += $1 if (/^(.).*\1$/);
$c += $1 while (s/(.)\1/$1/);
print "Part 1: $c\n";

$_ = $i;
$c = 0;
for my $i (0..length($_)-1) {
  my $ch = substr $_, $i, 1;
  if ($ch eq substr $_, ($i+length($_)/2) % length($_), 1) {
    $c += $ch;
  }
}
print 'Part 2: ', $c, "\n";
