#!/usr/bin/perl
use warnings;
use strict;

my $c1 = 0;
my $c2 = 0;
while (<>) {
  chomp;
  my $inside = "";
  while (s/\[([^\]]*)\]/:/) { $inside .= ":".$1 }
  $c1++ if (abba($_) && !abba($inside));
  my $recombined = $_.'!'.$inside;
  $c2++ if (ababab($recombined));
}
print "Part 1: $c1\n";
print "Part 2: $c2\n";

sub abba {
  $_[0] =~ /([^:])(?!\1)([^:])\2\1/;
}

sub ababab {
  $_[0] =~ /([^:])(?!\1)([^:])\1.*!.*\2\1\2/;
}
