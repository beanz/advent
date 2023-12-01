#!/usr/bin/env perl
use strict;
use warnings;
use constant { PRETTY => $ENV{PRETTY}//0 };
undef $/;
$_=<>;
$_.="\n\n";
$_=~s/\n\n/\n!\n/g;
$_=~s/\n/,\n/;
my $n = "";
s&(\d+),&
  my $c=$1;
  s/\b$c\b/$c>9?" X":"X"/ge;
  s/(\n!\n
     (?:
      (?:[^!]*?X\ +X\ +X\ +X\ +X\n?[^!]*?) |
      (?:\ X\ +?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+\n
         \ X\ +?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+\n
         \ X\ +?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+\n
         \ X\ +?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+\n
         \ X\ +?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+
       ) |
      (?:\ ?[\dX]+\ +X\ +[\dX]+\ +[\dX]+\ +[\dX]+\n
         \ ?[\dX]+\ +X\ +[\dX]+\ +[\dX]+\ +[\dX]+\n
         \ ?[\dX]+\ +X\ +[\dX]+\ +[\dX]+\ +[\dX]+\n
         \ ?[\dX]+\ +X\ +[\dX]+\ +[\dX]+\ +[\dX]+\n
         \ ?[\dX]+\ +X\ +[\dX]+\ +[\dX]+\ +[\dX]+
       ) |
      (?:\ ?[\dX]+\ +[\dX]+\ +X\ +[\dX]+\ +[\dX]+\n
         \ ?[\dX]+\ +[\dX]+\ +X\ +[\dX]+\ +[\dX]+\n
         \ ?[\dX]+\ +[\dX]+\ +X\ +[\dX]+\ +[\dX]+\n
         \ ?[\dX]+\ +[\dX]+\ +X\ +[\dX]+\ +[\dX]+\n
         \ ?[\dX]+\ +[\dX]+\ +X\ +[\dX]+\ +[\dX]+
       ) |
      (?:\ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +X\ +[\dX]+\n
         \ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +X\ +[\dX]+\n
         \ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +X\ +[\dX]+\n
         \ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +X\ +[\dX]+\n
         \ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +X\ +[\dX]+
       ) |
      (?:\ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+\ +X\n
         \ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+\ +X\n
         \ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+\ +X\n
         \ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+\ +X\n
         \ ?[\dX]+\ +[\dX]+\ +[\dX]+\ +[\dX]+\ +X
       )
     )
    )\n!\n/
    my $b = $1;
    my $s = 0;
    $b =~ s!(\d+)\s*!$s+=$1;"X"!eg;
    $n .= ($c*$s).";";
    "\n!\n";
   /segx;
  if (PRETTY) {
    print `tput clear`, $_;
    select undef, undef, undef, 0.1;
  }
  "";
&seg;
print "\n" if (PRETTY);
$_=$n;
s/.*\n//s;
s/;$/\n/;
s/;.*;/\nPart 2: /;
print "Part 1: ", $_;
