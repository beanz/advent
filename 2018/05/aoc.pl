#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

$_=$i[0];
my $r = join "|", map{ $_.uc$_, (uc$_).$_ } 'a' .. 'z';
while(s/$r//go){}
print 'Part 1: ', length $_, "\n";

$_=$i[0];

sub r{shift;while(s/$r//go){}~~y///c;}
my $m = 9e9;
r($_);
my $s=$_;
for my $c ('a'..'z') {
  $_=$s;
  s/$c//gi;
  my $n=r($_);
  $m = $m>$n ? $n : $m;
}
print 'Part 2: ', $m, "\n";


