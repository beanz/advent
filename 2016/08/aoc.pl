#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};
my $w = 50;
my $h = 6;
if ($file =~ /^test/) {
  $w = 7;
  $h = 3;
}

my %s;
for (@i) {
  print $_, "\n" if DEBUG;
  if (/rect (\d+)x(\d+)/) {
    my ($rw, $rh) = ($1, $2);
    for my $y (0..$rh-1) {
      for my $x (0..$rw-1) {
        $s{$y}->{$x} = 1;
      }
    }
  } elsif (/rotate row y=(\d+) by (\d+)/) {
    my ($y, $by) = ($1, $2);
    my %n;
    for my $x (keys %{$s{$y}}) {
      $n{($x+$by) % $w} = 1;
    }
    $s{$y} = \%n;
  } elsif (/rotate column x=(\d+) by (\d+)/) {
    my ($x, $by) = ($1, $2);
    my @p;
    for my $y (0..$h-1) {
      push @p, ($y+$by) % $h if (delete $s{$y}->{$x});
    }
    for my $y (@p) {
      $s{$y}->{$x} = 1;
    }
  } else {
    warn "Invalid instruction: $_\n";
  }
  print pp(\%s), "\n" if DEBUG;
}

my $count = sum(map { scalar keys %{$s{$_}} } keys %s);
print "Part 1: $count\n";
print "Part 2:\n\n", pp(\%s),"\n";

sub pp {
  my ($s) = @_;
  my $r = '';
  for my $y (0..($h-1)) {
    for my $x (0..($w-1)) {
      $r .= exists $s{$y}->{$x} ? '#' : '.';
    }
    $r .= "\n";
  }
  $r;
}

