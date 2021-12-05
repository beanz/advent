#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

use constant
  {
   YARD => 0,
   W => 1,
   H => 2,
   TREES => 0,
   LUMBER => 1,
   EMPTY => 2,
  };

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);
#dd([$i],[qw/i/]);

sub parse_input {
  my ($lines) = @_;
  return [ $lines, (scalar @$lines), length($lines->[0]) ];
}

sub square {
  my ($yard, $x, $y) = @_;
  return (substr $yard->[YARD]->[$y], $x, 1)
}

sub neighbour_counts {
  my ($l, $x, $y) = @_;
  state $neighbours = [[-1,1],[0,1],[1,1],[-1,0],[1,0],[-1,-1],[0,-1],[1,-1]];
  my @r = (0,0,0);
  for my $o (@$neighbours) {
    my $nx = $x + $o->[X];
    next if ($nx < 0 || $nx >= $l->[W]);
    my $ny = $y + $o->[Y];
    next if ($ny < 0 || $ny >= $l->[H]);
    my $sq = square($l, $nx, $ny);
    if ($sq eq '|') {
      $r[TREES]++;
    } elsif ($sq eq '#') {
      $r[LUMBER]++;
    } else {
      $r[EMPTY]++;
    }
  }
  return \@r;
}

sub pp {
  my ($l, $m) = @_;
  my $r = '';
  $r .= $m."\n" if (defined $m);
  for my $y (0..$l->[H]-1) {
    for my $x (0..$l->[W]-1) {
      $r .= square($l, $x, $y);
    }
    $r .= "\n";
  }
  return $r;
}

sub iter {
  my ($l) = @_;
  my @n;
  for my $y (0..$l->[H]-1) {
    my $new = '';
    for my $x (0..$l->[W]-1) {
      my $sq = square($l, $x, $y);
      my $c = neighbour_counts($l, $x, $y);
      if ($sq eq '.') {
        if ($c->[TREES] >= 3) {
          $new .= '|';
        } else {
          $new .= '.';
        }
      } elsif ($sq eq '|') {
        if ($c->[LUMBER] >= 3) {
          $new .= '#';
        } else {
          $new .= '|';
        }
      } else {
        if ($c->[TREES] >= 1 && $c->[LUMBER] >= 1) {
          $new .= '#';
        } else {
          $new .= '.';
        }
      }
      #print STDERR "check $x, $y: $sq @$c => $new\n" if DEBUG;
    }
    push @n, $new;
  }
  $l->[YARD] = \@n;
  return $l;
}

sub calc {
  my ($yard, $steps) = @_;
  print pp($yard), "\n" if DEBUG;
  for my $i (0..$steps-1) {
    iter($yard);
    print pp($yard, 'Iteration: '.$i),"\n" if DEBUG;
  }
  my $trees = sum(map { ~~y/\|// } @{$yard->[YARD]});
  my $lumber = sum(map { ~~y/#// } @{$yard->[YARD]});
  return $trees * $lumber;
}

my $test_input;
$test_input = parse_input([split/\n/, <<'EOF']);
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
EOF
#dd([$test_input],[qw/test_input/]);

if (TEST) {
  my $res;
  $res = square($test_input, 0, 0);
  print "Square Test 1a: $res == .\n";
  die "failed\n" unless ($res eq '.');
  $res = square($test_input, 1, 0);
  print "Square Test 1b: $res == #\n";
  die "failed\n" unless ($res eq '#');
  $res = neighbour_counts($test_input, 1, 0);
  print "Neighbours Test 1a: @$res == 0 0 5\n";
  die "failed\n" unless ("@$res" eq '0 0 5');
  $res = neighbour_counts($test_input, 8, 1);
  print "Neighbours Test 1b: @$res == 2 3 3\n";
  die "failed\n" unless ("@$res" eq '2 3 3');

  $res = calc($test_input, 10);
  print "Test 1: $res == 1147\n";
  die "failed\n" unless ($res eq 1147);
}

my $part1 = calc($i, 10);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($yard, $steps) = @_;
  my $value = 0;
  my $i = 0;
  my %seen;
  while ($i < $steps) {
    $value = calc($yard, 1);
    $i++;
    print "Iter: $i $value\n" if DEBUG;
    my $state = pp($yard);
    if ($i > 300 && $i < 100000) {
      if (exists $seen{$value}) {
        print "Cycle found: $value at $seen{$value} & $i\n" if DEBUG;
        my $cycle = $i - $seen{$value};
        print "Cycle length $cycle\n" if DEBUG;
        my $remaining = $steps - $i;
        print "Remaining steps: $steps - $i = $remaining\n" if DEBUG;
        $i += $cycle * int($remaining/$cycle);
        print "Incrementing iteration by ",
          $cycle * int($remaining/$cycle), "\n" if DEBUG;
        %seen = ();
      } else {
        $seen{$value} = $i;
      }
    }
  }
  return $value;
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i, 1000000000), "\n";
