#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant {
  ORD0 => ord('0'),
};

my @i = <>;
chomp @i;

my $r = $i[0];
my $end = $i[1];

my $e1 = 1;
my $e2 = 0;
my $p1;
my $p2;
while (1) {
  my $v1 = ord(substr $r, $e1, 1) - ORD0;
  my $v2 = ord(substr $r, $e2, 1) - ORD0;
  $r .= $v1 + $v2;
  $e1 = ( $e1 + $v1 + 1 ) % length($r);
  $e2 = ( $e2 + $v2 + 1 ) % length($r);
  if (!defined $p1 && (length $r) >= $end + 10) {
    $p1 = $r;
    $p1 = substr($p1, $end, 10)
  }
  if (((length $r)%100000) == 0) {
    print STDERR (length $r),"\r" if DEBUG;
    last if ($r =~ /$end/go);
  }
}

print STDERR "\n" if DEBUG;
print 'Part 1: ', $p1, "\n";
print 'Part 2: ', pos($r)-length($end), "\n";

