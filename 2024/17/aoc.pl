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

my $file = shift // "input.txt";

my $reader = \&read_stuff;

#my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %r;
  for (@$in) {
    if (/Register (.): (\d+)/) {
      $r{$1} = $2;
    } elsif (/Program: (.*)/) {
      $r{P} = [split /,/, $1];
      $r{IP} = 0;
    }
  }
  return \%r;
}

no warnings qw/recursion/;

sub try {
  my ($in, $i, $a) = @_;
  my $exp = substr "@{$in->{P}}", $i;

  #print STDERR "T: $a $i $exp\n";
  for my $c (0 .. 7) {
    my $out =
      run({P => $in->{P}, A => $c + 8 * $a, B => $in->{B}, C => $in->{C}});
    my $got = substr "@$out", $i;
    if ($exp eq $got) {
      if (-$i == length("@{$in->{P}}")) {
        return $c + 8 * $a;
      }
      my $res = try($in, $i - 2, $c + 8 * $a);
      if (defined $res) {
        return $res
      }
    }
  }
  return
}

sub calc {
  my ($in) = @_;
  my $p1 =
    "@{run({ P => $in->{P}, A => $in->{A}, B => $in->{B}, C=>$in->{C}})}";
  my $exp = "@{$in->{P}}";
  my $p2 = try($in, -1, 0);
  return [$p1, $p2];
}

sub run {
  my ($in) = @_;
  my $ip = 0;
  my @out;
  while ($ip < @{$in->{P}} - 1) {
    my $op = $in->{P}->[$ip];
    my $l = $in->{P}->[$ip + 1];
    my $c;
    if ($l <= 3) {
      $c = $l;
    } elsif ($l == 4) {
      $c = $in->{A};
    } elsif ($l == 5) {
      $c = $in->{B};
    } elsif ($l == 6) {
      $c = $in->{C};
    }
    if ($op == 0) {
      $in->{A} = int($in->{A} / (2**$c));
    } elsif ($op == 1) {
      $in->{B} ^= $l;
    } elsif ($op == 2) {
      $in->{B} = $c & 7;
    } elsif ($op == 3) {
      if ($in->{A} != 0) {
        $ip = $l;
        next;
      }
    } elsif ($op == 4) {
      $in->{B} ^= $in->{C};
    } elsif ($op == 5) {
      push @out, $c & 7;
    } elsif ($op == 6) {
      $in->{B} = int($in->{A} / (2**$c));
    } elsif ($op == 7) {
      $in->{C} = int($in->{A} / (2**$c));
    }
    $ip += 2;
  }
  return \@out;
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
