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
for (@i) {
  die "Illegal input: $_\n" if (/[^\w\\\"]/);
}

sub calc {
  my ($i) = @_;
  my $c = sum map { length($_) } @$i;
  my $s = sum map { my $l; eval '$l = '.$_; length($l) } @$i;
  print STDERR "calc: $c - $s = ", ($c - $s), "\n" if DEBUG;
  return $c - $s;
}

my @test_input = split/\n/, <<'EOF';
""
"abc"
"aaa\"aaa"
"\x27"
EOF
chomp @test_input;

if (TEST) {
  print "Test 1: ", calc(\@test_input), " == 12\n";
}
print "Part 1: ", calc(\@i), "\n";

sub calc2 {
  my ($i) = @_;
  my $c = sum map { length($_) } @$i;
  my $q = sum map { 2+length(quotemeta($_)) } @$i;
  print STDERR "calc: $q - $c = ", ($q - $c), "\n" if DEBUG;
  return $q - $c;
}

if (TEST) {
  print "Test 2: ", calc2(\@test_input), " == 19\n";
}
print "Part 2: ", calc2(\@i), "\n";
