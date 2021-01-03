#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant {
  PART => { map { $_ => 1 } split //, ($ENV{AoC_PART} // '12') },
};

my @i = <>;
chomp @i;

my %v;
sub cw {
  my ($l, $w, $n) = @_;
  print STDERR "CW: $l\n" if DEBUG;
  if (exists $w->{$n}) {
    return $w->{$n} if (!ref $w->{$n});
    return $w->{$n} = $w->{$n}->();
  } else {
    print STDERR "Wire $n is undefined in $l\n";
    return $w->{$n} = 0;
  }
}

sub apply {
  my ($w, $l) = @_;
  print STDERR "L: $l\n" if DEBUG;
  if ($l =~ /^(\d+) -> ([a-z]+)/) {
    $w->{$2} = 0 + $1;
  } elsif ($l =~ /^([a-z]+) -> ([a-z]+)/) {
    my $w1 = $1;
    $w->{$2} = sub { cw($l, $w, $w1) };
  } elsif ($l =~ /(\d+) AND ([a-z]+) -> ([a-z]+)/) {
    my $v = 0+$1;
    my $w2 = $2;
    $w->{$3} = sub { 0xffff & ($v & cw($l, $w, $w2)) };
  } elsif ($l =~ /([a-z]+) AND ([a-z]+) -> ([a-z]+)/) {
    my ($w1, $w2) = ($1, $2);
    $w->{$3} = sub { 0xffff & (cw($l, $w, $w1) & cw($l, $w, $w2)) };
  } elsif ($l =~ /([a-z]+) OR ([a-z]+) -> ([a-z]+)/) {
    my ($w1, $w2) = ($1, $2);
    $w->{$3} = sub { 0xffff & (cw($l, $w, $w1) | cw($l, $w, $w2)) };
  } elsif ($l =~ /([a-z]+) RSHIFT (\d+) -> ([a-z]+)/) {
    my ($w1, $v) = ($1, $2);
    $w->{$3} = sub { 0xffff & (cw($l, $w, $w1) >> $v) };
  } elsif ($l =~ /([a-z]+) LSHIFT (\d+) -> ([a-z]+)/) {
    my ($w1, $v) = ($1, $2);
    $w->{$3} = sub { 0xffff & (cw($l, $w, $w1) << $v) };
  } elsif ($l =~ /NOT ([a-z]+) -> ([a-z]+)/) {
    my $w1 = $1;
    $w->{$2} = sub { 0xffff & (cw($l, $w, $w1) ^ 0xffff) };
  } else {
    die "invalid op: $l\n";
  }
  print STDERR "W: ", (join ', ', sort keys %$w), "\n" if DEBUG;
}

my $part1;
if (PART->{1}) {
  if (TEST) {
    my @l = split /\n/, << 'EOF';
456 -> y
x AND y -> d
x OR y -> e
123 -> x
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i
EOF
    chomp @l;
    my %w;
    for my $l (@l) {
      apply(\%w, $l);
    }
    my %expect =
      (d => 72, e => 507, f => 492,
       g => 114, h => 65412, i => 65079, x => 123, y => 456);
    my $res = join ', ', map { $_.': '.$w{$_} } sort keys %w;
    for my $w (sort keys %expect) {
      assertEq("$w $expect{$w}", $expect{$w}, cw('test', \%w, $w));
    }
  }
  my %w;
  for my $l (@i) {
    apply(\%w, $l);
  }
  $part1 = cw('part 1', \%w, 'a');
  print "Part 1: ", $part1, "\n";
}

if (PART->{2}) {
  my %w;
  for my $l (@i) {
    apply(\%w, $l);
  }
  $w{b} = $part1 || 956;
  print "Part 2: ", cw('part 1', \%w, 'a'), "\n";
}
