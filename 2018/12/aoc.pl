#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $gen = @i < 20 ? 20 : 50000000000;
my $state = shift @i;
$state =~ s/.*: //;
#print STDERR $state, "\n";

my %r;
for (@i) {
  chomp;
  next unless (/([\.#]{5}) => \#/);
  $r{$1} = '#';
}

my $offset = 0;
my $sum = count($state, $offset);
my $diff = 0;
my $t = 1;
#print STDERR "0 [$offset]: $state $sum\n";
while ($t <= $gen) {
  $state = '....'.$state.'....';
  $offset += 4;
  my $new_state = '..';
  my $l = length($state)-2;
  for my $i (2..$l) {
    $new_state .= exists $r{(substr $state, $i-2, 5)} ? '#' : '.';
  }
  my $i = (index $new_state, '#');
  substr $new_state, 0, $i, '';
  $offset -= $i;
  $new_state =~ s/\.*$//;
  $state = $new_state;
  my $new_sum = count($state, $offset);
  my $new_diff = $new_sum - $sum;
  last if ($new_diff == $diff);
  $sum = $new_sum;
  $diff = $new_diff;
  if ($t == 20) {
    print 'Part 1: ', $new_sum, "\n";
  }
  #print STDERR "$t [$offset]: $state $sum\n";
  $t++;
}
$t--;
if ($t == $gen) {
  print "$gen: ", count($state, $offset), "\n" if DEBUG;
} else {
  my $sum = $sum + $diff * ($gen - $t);
  print "$gen: $sum\n" if DEBUG;
  print 'Part 2: ', $sum, "\n";
}

sub count {
  my ($state, $offset) = @_;
  my $count = 0;
  for my $i (0..length($state)-1) {
    if ((substr $state, $i, 1) eq "#") {
      $count += $i - $offset;
    }
  }
  return $count;
}
