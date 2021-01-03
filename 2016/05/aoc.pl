#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Digest::MD5 qw/md5_hex/;

my $input = <>;
chomp($input);

my $iter = iter($input);
my $s = "";
for (0..7) {
  $s .= substr $iter->(), 5, 1;
}
print "Part 1: $s\n";

$s = "________";
$iter = iter($input);
while ($s =~ /_/) {
  my $sum = $iter->();
  my $pos = substr $sum, 5, 1;
  my $ch = substr $sum, 6, 1;
  if ($pos !~ /[0-7]/) {
    next;
  }
  if ("_" ne substr $s, $pos, 1) {
    next;
  }
  substr $s, $pos, 1, $ch;
}

print "Part 2: $s\n";

sub iter {
  my $id = shift;
  my $index = 0;
  return sub {
    my $s;
    do {
      $s = md5_hex($id.$index);
      $index++;
    } until ($s =~ /^00000/);
    return $s;
  }
}
