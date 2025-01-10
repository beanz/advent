#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use File::Temp qw/tempfile/;

#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_slurp;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my ($fh, $filename) = tempfile;
  $in =~ s/<->/--/g;
  $in =~ s/,/ -- /g;
  print $fh "graph d12 {\n$in}\n";
  close $fh;
  my $p1 = `ccomps -X 0 < $filename | gc -n`;
  $p1 =~ s/.*?(\d+)\b.*/$1/s;
  my $p2 = `gc -c < $filename`;
  $p2 =~ s/.*?(\d+)\b.*/$1/s;
  return [$p1, $p2];
}

RunTests(sub { my $f = shift; calc($reader->($f), @_) }) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
