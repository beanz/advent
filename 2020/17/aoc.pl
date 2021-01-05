#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$;= $" = ',';

my $file = shift // "input.txt";
my $i = read_map($file, 3);
my $i2 = read_map($file, 4);
#my $i3 = read_map($file, 5);

sub read_map {
  my ($file, $dim) = @_;
  my $lines = read_lines($file);
  my $bb = [];
  my %m = ();
  for my $y (0..(@$lines-1)) {
    for my $x (0..(length $lines->[0])-1) {
      my @c = ($x, $y);
      push @c, 0 for (0..$dim-3);
      if ('#' eq substr $lines->[$y], $x, 1) {
        $m{"@c"} = 1;
        minmax_dim($bb, @c);
      }
    }
  }
  return { map => \%m, bb => $bb, dim => $dim, nb => [neighbours($dim)] };
}

sub sq {
  my ($m, @c) = @_;
  exists $m->{map}->{"@c"};
}

sub nc {
  my ($m, @c) = @_;
  my $c = 0;
  for my $n (@{$m->{nb}}) {
    my @nc = map { $c[$_] + $n->[$_] } (0..@c-1);
    if (exists $m->{map}->{"@nc"}) {
      $c++;
    }
  }
  $c;
}

sub pretty {
  my ($m) = @_;
  my $s = "";
  for my $z ($m->{bb}->[Z]->[MIN] .. $m->{bb}->[Z]->[MAX]) {
    $s .= "z=".$z."\n";
    for my $y ($m->{bb}->[Y]->[MIN] .. $m->{bb}->[Y]->[MAX]) {
      for my $x ($m->{bb}->[X]->[MIN] .. $m->{bb}->[X]->[MAX]) {
        $s .= exists $m->{map}->{$x, $y, $z} ? '#' : '.';
      }
      $s .= " ($y)\n";
    }
    $s .= "\n";
  }
  return $s;
}

sub iter {
  my ($m) = @_;
  my $n = { map => {}, bb => [], dim => $m->{dim}, c => 0, nb => $m->{nb} };
  minmax_dim($n->{bb}, map { $m->{bb}->[$_]->[MIN]-1 } (0..$m->{dim}-1));
  minmax_dim($n->{bb}, map { $m->{bb}->[$_]->[MAX]+1 } (0..$m->{dim}-1));
  # check whole bounding box ... slower # for my $c (allin($n->{bb})) {
  my %cache;
  for my $c (allneighbours($m->{nb},
                           [map { [ split/,/,$_ ] } keys %{$m->{map}}])) {
    my @rk = @$c;
    for my $i (2..@rk-1) {
      $rk[$i] = abs($rk[$i]);
    }
    my $rk = join'!',@rk;
    my $nc;
    if ($cache{$rk}) {
      $nc = $cache{$rk};
    } else {
      $cache{$rk} = $nc = nc($m, @$c);
    }
    my $sq = sq($m, @$c);
    if (($sq && $nc == 2) || $nc == 3) {
      $sq = 1;
    } else {
      undef $sq;
    }
    if ($sq) {
      $n->{c}++;
      $n->{map}->{"@$c"} = 1;
    }
  }
  print "Live: $n->{c}\n" if DEBUG;
  print pretty($m) if (DEBUG > 1);
  return $n;
}

sub calc {
  my ($m) = @_;
  for (0..5) {
    $m = iter($m);
  }
  return $m->{c};
}

testCalc() if (TEST);

print "Part 1: ", calc($i), "\n";
print "Part 2: ", calc($i2), "\n";

#print "Part 3: ", calc($i3), "\n";

sub testCalc {
  my @test_cases =
    (
     [ "test1.txt", 3, 112 ],
     [ "test1.txt", 4, 848 ],
     # [ "test1.txt", 5, 5760 ], # works but slow
     # [ "input.txt", 5, 11408 ], # works but slow
    );
  for my $tc (@test_cases) {
    my $res = calc(read_map($tc->[0], $tc->[1]));
    assertEq("Test [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}
