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
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m = (lines => [map {[split //]} @$in]);
  $m{h} = scalar @$in;
  $m{w} = length $in->[0];
  return \%m;
}

sub at {
  my ($in, $x, $y) = @_;
  if ($x >= 0 && $x < $in->{w} && $y >= 0 && $y < $in->{h}) {
    return $in->{lines}->[$y]->[$x];
  }
  return '.';
}

sub sym {
  my $s = at(@_);
  if ($s !~ /[0-9\.]/) {
    return $s;
  }
  return;
}

sub parts {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  my %seen;
  for my $y (0 .. $in->{h} - 1) {
    my $x = 0;
    while ($x < $in->{w}) {
      my $sch = undef;
      my $n = 0;
      while ($x < $in->{w}) {
        my $d = at($in, $x, $y);
        if ($d =~ /\D/) {
          last;
        }
        $n = $n * 10 + $d;
      LOOP:
        for my $ox (-1 .. 1) {
          for my $oy (-1 .. 1) {
            my $sym = sym($in, $x + $ox, $y + $oy);
            if ($sym) {
              $sch = [$sym, $x + $ox, $y + $oy];
              last LOOP;
            }
          }
        }
        $x++;
      }
      if ($sch) {
        print STDERR "F: $n $sch->[0]\n" if DEBUG;
        $p1 += $n;
        my ($sym, $sx, $sy) = @$sch;
        if ($sym eq '*') {
          my $o = $seen{$sx, $sy};
          if ($o) {
            $p2 += $n * $o;
          } else {
            $seen{$sx, $sy} = $n;
          }
        }
      }
      $x++;
    }
    $x = 0;
  }
  return [$p1, $p2];
}

testParts() if (TEST);

my $r = parts($i);
print "Part 1: ", $r->[0], "\n";
print "Part 2: ", $r->[1], "\n";

sub testParts {
  my @test_cases =
    (["test1.txt", 4361, 467835], ["input.txt", 549908, 81166799],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[2]);
  }
}
