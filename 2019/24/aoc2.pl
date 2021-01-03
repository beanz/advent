#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = <>;
chomp @i;

sub parse_input {
  my ($lines) = @_;
  my $m = join '', @$lines;
  my $n = 0;
  my $i = 0;
  while ($i < length($m)) {
    my $p = index $m, '#', $i;
    last if ($p == -1);
    $n += 2**$p;
    $i = $p+1;
  }
  return { 0 => $n };
}

sub bug {
  my ($m, $d, $x, $y) = @_;
  die "X=2 Y=2!" if ($x == 2 && $y == 2);
  my $n = $m->{$d} // 0;
  die if ($y < 0 || $y >= 5 || $x < 0 || $x >= 5);
  return ($n & 2**($y*5 + $x));
}

sub ppn {
  my ($n) = @_;
  return '['.(join ' ', map { "{@$_}" } @$n).']';
}

sub neighbours {
  my ($d, $x, $y) = @_;
  my @r;
  # neighbour(s) above
  if ($y == 0) {
    push @r, [$d-1, 2, 1];
  } elsif ($y == 3 && $x == 2) {
    push @r, map { [ $d+1, $_, 4] } (0..4);
  } else {
    push @r, [$d, $x, $y-1];
  }

  # neighbour(s) below
  if ($y == 4) {
    push @r, [$d-1, 2, 3];
  } elsif ($y == 1 && $x == 2) {
    push @r, map { [ $d+1, $_, 0] } (0..4);
  } else {
    push @r, [$d, $x, $y+1];
  }

  # neighbour(s) left
  if ($x == 0) {
    push @r, [$d-1, 1, 2];
  } elsif ($x == 3 && $y == 2) {
    push @r, map { [ $d+1, 4, $_] } (0..4);
  } else {
    push @r, [$d, $x-1, $y];
  }

  # neighbour(s) right
  if ($x == 4) {
    push @r, [$d-1, 3, 2];
  } elsif ($x == 1 && $y == 2) {
    push @r, map { [ $d+1, 0, $_] } (0..4);
  } else {
    push @r, [$d, $x+1, $y];
  }
  return \@r;
}

sub life {
  my ($m, $d, $x, $y) = @_;
  my $c = 0;
  for my $nb (@{neighbours($d, $x, $y)}) {
    $c++ if (bug($m, @$nb));
  }
  return $c == 1 || (!bug($m, $d, $x, $y) && $c == 2);
}

sub pp {
  my ($m) = @_;
  my $s = "";
  for my $d (sort { $a <=> $b } keys %$m) {
    my $n = $m->{$d};
    $s .= "Depth $d\n$n\n";
    for my $y (0..4) {
      for my $x (0..4) {
        $s .= ($y == 2 && $x == 2) ? '?' : bug($m, $d, $x, $y) ? '#' : '.';
      }
      $s .= "\n";
    }
    $s .= "\n";
  }
  return $s;
}

sub count {
  my ($m) = @_;
  my $c = 0;
  for my $d (sort { $a <=> $b } keys %$m) {
    my $n = $m->{$d};
    for my $y (0..4) {
      for my $x (0..4) {
        $c += ($y == 2 && $x == 2) ? 0 : bug($m, $d, $x, $y) ? 1 : 0;
      }
    }
  }
  return $c;
}

sub calc {
  my ($m, $c) = @_;
  for (1..$c) {
    my $n;
    my $minD = min(keys %$m)-1;
    my $maxD = max(keys %$m)+1;
    my %n;
    for my $d ($minD .. $maxD) {
      #print "Checking depth $d\n";
      my $new = 0;
      for my $y (0..4) {
        for my $x (0..4) {
          next if ($x == 2 && $y == 2);
          my $a = $y*5 + $x;
          if (life($m, $d, $x, $y)) {
            $new += 2**$a;
          }
        }
      }
      $n->{$d} = $new if ($new != 0 || $d == 0);
    }
    $m = $n;
    #print pp($m);
  }
  return count($m);
}

if (TEST) {
  my @TESTS =
    (
     [ "Tile 19 has four adjacent tiles: 14, 18, 20, and 24", [0,3,3], 4 ],
     [ "Tile G has four adjacent tiles: B, F, H, and L", [1, 1, 1], 4 ],
     [ "Tile D has four adjacent tiles: 8, C, E, and I", [1, 3, 0], 4 ],
     [ "Tile E has four adjacent tiles: 8, D, 14, and J", [1, 4, 0], 4 ],
     [ "Tile 14 has eight adjacent tiles: 9, E, J, O, T, Y, 15, and 19",
       [0, 3, 2], 8 ],
     [ "Tile N has eight adjacent tiles: I, O, S, and 5 in sub-grid ?",
       [1, 3, 2], 8 ],
    );
  for my $tc (@TESTS) {
    my $neighbours = neighbours(@{$tc->[1]});
    #print ppn($neighbours), "\n";
    assertEq("Test \"$tc->[0]\"", scalar @$neighbours, $tc->[2]);
  }
  assertEq("Test Example", calc(parse_input(read_lines("test.txt")),10),
           99);
}

my $m = parse_input(\@i);
print "Part 2: ", calc($m, 1), "\n";
