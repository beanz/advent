#!/usr/bin/perl
use warnings;
use strict;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
  ORD0 => ord('0'),
};

my $r = <>;
chomp $r;
my $end = <>;
chomp $end;

my $e1 = 1;
my $e2 = 0;
while (1) {
  my $v1 = ord(substr $r, $e1, 1) - ORD0;
  my $v2 = ord(substr $r, $e2, 1) - ORD0;
  $r .= $v1 + $v2;
  $e1 = ( $e1 + $v1 + 1 ) % length($r);
  $e2 = ( $e2 + $v2 + 1 ) % length($r);
  if ((length $r) >= $end + 10) {
    last;
  }
  print STDERR length($r), "\r" if DEBUG;
}

print STDERR "\n" if DEBUG;
print substr($r, $end, 10), "\n";
