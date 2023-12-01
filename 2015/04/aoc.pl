#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Digest::MD5 qw/md5_hex/;

sub adventcoin {
 my ($secret, $num) = @_;
 $num //= 5;
 my $zeroes = '0' x $num;
 my $i = 1;
 while (1) {
   printf STDERR "%d\r", $i if (DEBUG && !($i%100));
   my $d = md5_hex($secret.$i);
   last if ($zeroes eq substr $d, 0, $num);
   $i++;
 }
 print STDERR "\n" if DEBUG;
 return $i;
}

if (TEST) {
  assertEq("adventcoin('abcdef')", adventcoin('abcdef'), 609043);
  assertEq("adventcoin('pqrstuv')", adventcoin('pqrstuv'), 1048970);
}

my $i = read_lines(shift//"input.txt")->[0];
print "Part 1: ", adventcoin($i), "\n";
print "Part 2: ", adventcoin($i, 6), "\n";
