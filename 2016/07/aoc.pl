#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = @{read_lines(shift//"input.txt")};
my $c1 = 0;
my $c2 = 0;
for (@i) {
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
