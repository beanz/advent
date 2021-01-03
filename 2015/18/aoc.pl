#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant
  {
   LIGHTS => 0,
   H => 1,
   W => 2,
   P2 => 3,
  };

my @i = <>;
chomp @i;

sub pp {
  my ($l, $m) = @_;
  my $r = '';
  $r .= $m."\n" if (defined $m);
  for my $y (0..$l->[H]-1) {
    for my $x (0..$l->[W]-1) {
      $r .= on($l, $x, $y) ? '#' : '.';
    }
    $r .= "\n";
  }
  return $r;
}

sub count_on {
  my ($l) = @_;
  my $s = sum(map { scalar($_ =~ y/#//) } @{$l->[LIGHTS]});
  if ($l->[P2]) {
    for my $p ([0,0], [$l->[H]-1, $l->[W]-1],
               [0, $l->[W]-1], [$l->[H]-1, 0]) {
      unless ((substr $l->[LIGHTS]->[$p->[Y]], $p->[X], 1) eq '#' ? 1 : 0) {
        $s++;
      }
    }
  }
  return $s;
}

sub on {
  my ($l, $x, $y) = @_;
  if ($l->[P2] &&
      ( $x == 0 || $x == ($l->[W]-1) ) &&
      ( $y == 0 || $y == ($l->[H]-1) )) {
    return 1;
  }
  return (substr $l->[LIGHTS]->[$y], $x, 1) eq '#' ? 1 : 0;
}

sub neighbours_count {
  my ($l, $x, $y) = @_;
  state $neighbours = [[-1,1],[0,1],[1,1],[-1,0],[1,0],[-1,-1],[0,-1],[1,-1]];
  my $c = 0;
  for my $o (@$neighbours) {
    my $nx = $x + $o->[X];
    next if ($nx < 0 || $nx >= $l->[W]);
    my $ny = $y + $o->[Y];
    next if ($ny < 0 || $ny >= $l->[H]);
    if (on($l, $nx, $ny)) {
      $c++;
    }
  }
  return $c;
}

sub iter {
  my ($l) = @_;
  my @n;
  for my $y (0..$l->[H]-1) {
    my $new = '';
    for my $x (0..$l->[W]-1) {
      #print STDERR "checking $x, $y\n" if DEBUG;
      my $n_on = neighbours_count($l, $x, $y);
      #print STDERR "  $n_on\n" if DEBUG;
      if ( ( on($l, $x, $y) && ($n_on == 2 || $n_on == 3) ) || $n_on == 3) {
        $new .= '#';
      } else {
        $new .= '.';
      }
    }
    push @n, $new;
  }
  $l->[LIGHTS] = \@n;
  return $l;
}

sub lines2lights {
  my $lines = shift;
  my $lights = [ $lines, (scalar @$lines), length($lines->[0]) ];
}

sub calc {
  my ($lights, $steps) = @_;
  print pp($lights), "\n" if (DEBUG > 1);
  for my $i (0..$steps-1) {
    print STDERR "Iteration: $i\r" if DEBUG;
    iter($lights);
    print pp($lights),"\n" if (DEBUG > 1);
  }
  print STDERR "\n" if DEBUG;
  return count_on($lights);
}

my @test_input = split/\n/, <<'EOF';
.#.#.#
...##.
#....#
..#...
#.#..#
####..
EOF
chomp @test_input;

if (TEST) {
  my $lights = lines2lights(\@test_input);
  my @on_tests = ([0, 0, 0], [1, 0, 1]);
  for my $test (@on_tests) {
    my ($x, $y, $exp) = @$test;
    my $on = on($lights, $x, $y) ? 1 : 0;
    assertEq("on test $x,$y", $on, $exp);
  }

  my @neighbour_tests = ([0, 0, 1], [5, 5, 1], [1, 4, 6]);
  for my $test (@neighbour_tests) {
    my ($x, $y, $exp) = @$test;
    my $num = neighbours_count($lights, $x, $y);
    assertEq("neighbour $x,$y", $num, $exp);
  }

  my $res = calc($lights, 4);
  assertEq("Test 1", $res, 4);
}

my $lights = lines2lights(\@i);

if (DEBUG) {
  printf "Dimensions %dx%d (WxH)\n", $lights->[W], $lights->[H];
  print "Initial on: ", count_on($lights), "\n";
}
print "Part 1: ", calc($lights, 100), "\n";

if (TEST) {
  my $lights = lines2lights(\@test_input);
  my @on_tests = ([0, 0], [0, 5], [5, 0], [5, 5]);
  $lights->[P2] = 1;
  for my $test (@on_tests) {
    my $on = on($lights, @$test) ? 1 : 0;
    assertEq("neighbour @$test", $on, 1); 
  }

  my $res = calc($lights, 5);
  print "Test 2: $res == 17\n";
  die "failed\n" unless ($res == 17);
}

$lights = lines2lights(\@i);
$lights->[P2] = 1;
print "Initial on: ", count_on($lights), "\n" if DEBUG;
print "Part 2: ", calc($lights, 100), "\n";
