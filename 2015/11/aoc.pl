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

sub calc {
  my ($i) = @_;
  do {
    ++$i
  } while (!valid($i));
  return $i;
}

my $straight = join '|', map { my $b = $_; ($_).(++$b).(++$b) } 'a' .. 'x';

sub valid {
  my ($p) = @_;
  return unless ($p =~ /$straight/o);
  return if ($p =~ /[iol]/);
  return unless ($p =~ /([a-z])\1.*([a-z])\2/);
  return 1;
}

my @test_input = split/\n/, <<'EOF';
EOF
chomp @test_input;

if (TEST) {
  for my $invalid (qw/hijklmmn abbceffg abbcegjk/) {
    die "should be invalid: $invalid\n" unless (!valid($invalid));
    print STDERR "invalid: $invalid\n";
  }
  for my $valid (qw/abcdffaa ghjaabcc/) {
    die "should be valid: $valid\n" unless (valid($valid));
    print STDERR "valid: $valid\n";
  }
  my %tests = qw/abcdefgh abcdffaa ghijklmn ghjaabcc/;
  for my $in (keys %tests) {
    my $out = calc($in);
    print "calc($in) = ", $out, " == ", $tests{$in}, "\n";
  }
}
my $part1 = calc($i[0]);
print "Part 1: ", $part1, "\n";
print "Part 2: ", calc($part1), "\n";
