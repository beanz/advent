#!/usr/bin/perl -l

use warnings;
use strict;

while (<>) {
  if (/(\d+) players; last marble is worth (\d+) points/) {
    print play($1,$2);
  }
}

sub pp {
  my ($cm, $c) = @_;
  my $i = 0;
  print join " ", map { $i++ == $cm ? "(".$_.")" : $_ } @$c;
}

sub play {
  my ($players, $num) = @_;
  #print "$players $num";
  my $cm = 0;
  my $ms = 0;
  my @s;
  my @c = (0);
  #pp($cm,\@c);
  for my $m (1..$num) {
    if (($m%23)==0) {
      #print "!\n";
      $s[($m-1)%$players]+=$m;
      my $i = ($cm - 7) % @c;
      my $r = splice @c, $i, 1;
      $cm = $i;
      $s[($m-1)%$players]+=$r;
      if ($s[($m-1)%$players] > $ms) {
        $ms = $s[($m-1)%$players];
      }
    } else {
      my $i = ($cm + 1)%@c;
      #print "cm=",$m-1, " cmi=", $cm, " n=", $i;
      splice @c, $i+1, 0, $m;
      $cm = $i+1;
    }
    #pp($cm,\@c);
  }
  return $ms;
}
