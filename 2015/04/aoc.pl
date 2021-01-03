#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use List::Util qw/min product pairs/;
use Carp::Always qw/carp verbose/;
use Digest::MD5 qw/md5_hex/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
};


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

print adventcoin("abcdef"), " = 609043\n";
print adventcoin("pqrstuv"), " = 1048970\n";

my $i = <>;
chomp $i;
print "Part 1: ", adventcoin($i), "\n";
print "Part 1: ", adventcoin($i, 6), "\n";
