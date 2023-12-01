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
  my $in = read_chunks($file);
  my %m = ( m => {}, f => [], bb => [], );
  for (split/\n/, $in->[0]) {
    my ($x,$y) = split/,/;
    minmax_xy($m{bb}, $x, $y);
    $m{m}->{$x,$y} = 1;
  }
  $m{f} = [split /\n/, $in->[1]];
  return \%m;
}

sub pp {
  my ($m) = @_;
  my $s = "";
  for my $y ($m->{bb}->[MINY]..$m->{bb}->[MAXY]) {
    for my $x ($m->{bb}->[MINX]..$m->{bb}->[MAXX]) {
      $s .= $m->{m}->{$x,$y} ? "#" : " ";
    }
    $s .= "\n";
  }
  return $s;
}

sub calc {
  my ($m) = @_;
  my $p1;
  for my $fold (@{$m->{f}}) {
    my ($f, $n) = ($fold =~ m/([xy])=(\d+)/);
    #print pp($m);
    #print "@{$m->{bb}}\n";
    #print "$f $n\n";
    $m->{bb} = [];
    if ($f eq "y") {
      for my $xy (keys %{$m->{m}}) {
        my ($x, $y) = split/,/, $xy;
        if ($y > $n) {
          delete $m->{m}->{$xy};
          $y = ($n-($y-$n));
          $m->{m}->{$x,$y} = 1;
        }
        minmax_xy($m->{bb}, $x, $y);
      }
    } else {
      for my $xy (keys %{$m->{m}}) {
        my ($x, $y) = split/,/, $xy;
        if ($x > $n) {
          delete $m->{m}->{$xy};
          $x = ($n-($x-$n));
          $m->{m}->{$x,$y} = 1;
        }
        minmax_xy($m->{bb}, $x, $y);
      }
    }
    if (!defined $p1) {
      $p1 = ~~keys %{$m->{m}};
    }
  }
  return [$p1, pp($m)];
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  return $c;
}

testParts() if (TEST);

my $r = calc($i);
print "Part 1: $r->[0]\nPart 2:\n$r->[1]\n";

sub testParts {
  my @test_cases =
    (
     [ "test1.txt", 17, "#####\n#   #\n#   #\n#   #\n#####\n" ],
     [ "input.txt", 747, " ##  ###  #  # #### ###   ##  #  # #  #
#  # #  # #  #    # #  # #  # #  # #  #
#  # #  # ####   #  #  # #    #  # ####
#### ###  #  #  #   ###  #    #  # #  #
#  # # #  #  # #    #    #  # #  # #  #
#  # #  # #  # #### #     ##   ##  #  #
" ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
