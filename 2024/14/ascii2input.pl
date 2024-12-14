#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "flip.ascii";

my $i = read_slurp($file);
$i =~ s/#/1/g;
my $h = ($i=~y/\n//);
my $w = index($i, "\n");
print STDERR "$w x $h\n";
print STDERR ~~($i=~y/1//), "\n";
print STDERR ~~($i=~y/@//), "\n";

my @l = map { [ split // ] } split/\n/, $i;
my @p;
for my $y (0..$h-1) {
  for my $x (0..$w-1) {
    if ($l[$y]->[$x] eq '1') {
      push @p, [$x, $y, int(rand 200)-100,  int(rand 200)-100];
    } elsif ($l[$y]->[$x] eq '@') {
      push @p, [$x, $y, int(rand 200)-100,  int(rand 200)-100, 1];
    }
  }
}
print STDERR ~~@p, "\n";
my $t = int(3000+rand(5000));
print STDERR "$t\n";
for my $p (@p) {
  my ($x, $y, $vx, $vy, $f) = @$p;
  print "p=", (($x-$t*$vx)%$w), ",",(($y-$t*$vy)%$h), " v=$vx,$vy",
   (defined $f ? ",$f" : ""), "\n";
}
    

