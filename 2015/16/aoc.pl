#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use List::Util qw/min max minstr maxstr sum product pairs/;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
  TEST => $ENV{AoC_TEST},
};

my @i = <>;
chomp @i;

my @tape_input = split/\n/, <<'EOF';
children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1
EOF
chomp @tape_input;

my %attr;
for (@tape_input) {
  my ($k, $v) = split /: /;
  $attr{$k} = $v;
}

sub calc {
  my ($i, $attr) = @_;
 LOOP:
  for my $l (@$i) {
    my ($num, $r) = ($l =~ /Sue (\d+): (.*)/);
    my %a = split /(?:, |:)/, $r;
    for my $a (keys %a) {
      if (exists $attr->{$a}) {
        next LOOP unless ($a{$a} == $attr->{$a})
      }
    }
    return $num;
  }
  return '-1';
}

print "Part 1: ", calc(\@i, \%attr), "\n";

sub calc2 {
  my ($i, $attr) = @_;
 LOOP:
  for my $l (@$i) {
    my ($num, $r) = ($l =~ /Sue (\d+): (.*)/);
    my %a = split /(?:, |:)/, $r;
    for my $a (keys %a) {
      if (exists $attr->{$a}) {
        if ($a eq 'cats' || $a eq 'trees') {
          next LOOP unless ($a{$a} > $attr->{$a});
        } elsif ($a eq 'pomeranians' || $a eq 'goldfish') {
          next LOOP unless ($a{$a} < $attr->{$a});
        } else {
          next LOOP unless ($a{$a} == $attr->{$a});
        }
      }
    }
    return $num;
  }
  return '-1';
}

print "Part 2: ", calc2(\@i, \%attr), "\n";
