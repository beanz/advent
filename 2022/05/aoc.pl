#!/usr/bin/perl
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
#my $reader = \&read_guess;
my $i = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_guess($file);
  my @c = ();
  my @c2 = ();
  my %m = ( m => $in->[1], cr => \@c, cr2 => \@c2 );
  CRANE:
  while (my $l = shift @{$in->[0]}) {
    last if ($l eq "");
    for my $c (0..9) {
      my $cr = substr $l.(" " x 80), 1+($c*4), 1;
      if ($cr eq "1") {
        last CRANE;
      }
      if ($cr eq " ") {
        next;
      }
      push @{$c[$c]}, $cr;
      push @{$c2[$c]}, $cr;
    }
  }
  return \%m;
}

sub calc {
  my ($in) = @_;
  for my $l (@{$in->{m}}) {
    my (undef, $n, undef, $c0, undef, $c1) = @$l;
    $c0--;
    $c1--;
    for (0..$n-1) {
      my @cr = shift @{$in->{cr}->[$c0]};
      unshift @{$in->{cr}->[$c1]}, @cr;
    }
  }
  my $s;
  for my $cr (@{$in->{cr}}) {
    $s .= $cr->[0];
  }
  return $s;
}

sub calc2 {
  my ($in) = @_;
  for my $l (@{$in->{m}}) {
    my (undef, $n, undef, $c0, undef, $c1) = @$l;
    $c0--;
    $c1--;
    my @cr = splice @{$in->{cr2}->[$c0]}, 0, $n, ();
    unshift @{$in->{cr2}->[$c1]}, @cr;
  }
  my $s;
  for my $cr (@{$in->{cr2}}) {
    $s .= $cr->[0];
  }
  return $s;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 10 ],
     [ "input.txt", 307 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 1, 15 ],
     [ "test1.txt", 2, 12 ],
     [ "test1.txt", 10, 37 ],
     [ "test1.txt", 100, 2208 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 2 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}
