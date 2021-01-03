#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = <>;
chomp @i;

my $c2;
my $c3;
for (@{[@i]}) {
  $_=join"",sort split//;s/(.)\1{3,}//g;
  $c3++ if (s/(.)\1\1//g);
  $c2++ if(s/(.)\1//g);
}

print 'Part 1: ', $c2*$c3, "\n";

for my $i (0..$#i) {
  for my $j ($i..$#i) {
    my $c="";
    my $d=0;
    for my$k(0..length($i[$i])-1){
      if(substr($i[$i],$k,1) eq substr($i[$j],$k,1)){
        $c.=substr($i[$i],$k,1)
      } else {
        $d++
      }
    }
    if ($d==1) {
      print 'Part 2: ', $c, "\n";
      exit;
    }
  }
}
