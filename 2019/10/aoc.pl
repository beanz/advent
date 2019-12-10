#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  my %a;
  my $best = hk(-1,-1);
  for my $y (0..@{$lines}-1) {
    my @line = split//,$lines->[$y];
    for my $x (0..@line-1) {
      if ($line[$x] eq '#') {
        $a{hk($x,$y)}=1;
      }
      if ($line[$x] eq 'X') {
        $a{hk($x,$y)}=1;
        $best = hk($x,$y);
      }
    }
  }
  return { m => \%a, cache => {}, best => $best };
}

sub gcd {
  my ($a, $b) = @_;
  $a = abs($a);
  $b = abs($b);
  ($a,$b) = ($b,$a) if $a > $b;
  while ($a) {
    ($a, $b) = ($b % $a, $a);
  }
  return $b;
}

sub num_blockers {
  my ($a, $a1, $a2) = @_;
  return $a->{cache}->{$a1.'-'.$a2} if (exists $a->{cache}->{$a1.'-'.$a2});
  my ($x1,$y1) = @{kh($a1)};
  my ($x2,$y2) = @{kh($a2)};
  print "v: $x1,$y1 => $x2,$y2\n" if DEBUG;
  my $blockers = 0;
  if ($x1 == $x2) {
    for my $y (min($y1, $y2)+1..max($y1, $y2)-1) {
      print "  checking $x1,$y\n" if DEBUG;
      if (exists $a->{m}->{hk($x1,$y)}) {
        print "  blocked by $x1,$y (dx==0)\n" if DEBUG;
        $blockers++;
      }
    }
  } elsif ($y1 == $y2) {
    for my $x (min($x1, $x2)+1..max($x1, $x2)-1) {
      print "  checking $x,$y1\n" if DEBUG;
      if (exists $a->{m}->{hk($x,$y1)}) {
        print "  blocked by $x,$y1 (dy==0)\n" if DEBUG;
        $blockers++;
      }
    }
  } else {
    my $dx = $x2-$x1;
    my $dy = $y2-$y1;
    print "  d: [$dx,$dy]\n" if DEBUG;
    my $gcd = gcd($dx, $dy);
    print "  gcd: $gcd\n" if DEBUG;
    $dx /= $gcd;
    $dy /= $gcd;
    print "  scaled: [$dx,$dy]\n" if DEBUG;
    my $x = $x1 + $dx;
    my $y = $y1 + $dy;
    print "  $x, $y\n" if DEBUG;
    while ($x != $x2 && $y != $y2) {
      print "  checking $x,$y\n" if DEBUG;
      if (exists $a->{m}->{hk($x,$y)}) {
        print "  blocked by $x,$y\n" if DEBUG;
        $blockers++;
      }
      $x += $dx;
      $y += $dy;
    }
  }
  $a->{cache}->{$a1.'-'.$a2} = $blockers;
  $a->{cache}->{$a2.'-'.$a1} = $blockers;
  return $blockers;
}

sub calc {
  my ($a) = @_;
  my $max;
  my %m;
  for my $a1 (keys %{$a->{m}}) {
    my $c = 0;
    for my $a2 (keys %{$a->{m}}) {
      next if ($a1 eq $a2);
      $c++ if (num_blockers($a, $a1, $a2) == 0);
    }
    $m{$a1}=$c;
    if (!defined $max || $max < $c) {
      $a->{best} = $a1;
      $max = $c;
    }
  }
  if (DEBUG) {
    for my $y (0..4) {
      for my $x (0..4) {
        printf "%3s", $m{hk($x,$y)}//'...';
      }
      print "\n";
    }
  }
  return $max;
}

if (TEST) {
  assertEq("GCD(54, 24)", gcd(54,24), 6);
  assertEq("GCD(2, 7)", gcd(-2,-7), 1);
  my $ast = parse_input([".#..#", ".....", "#####", "....#", "...##"]);
  my @blockers_tc =
    (
     ["3!4", "1!0", 1],
     ["4!4", "4!2", 1],
     ["3!4", "2!2", 0],
     ["3!4", "4!0", 0],
     ["4!4", "4!0", 2],
     ["4!4", "4!3", 0],
     );
  for my $btc (@blockers_tc) {
    my $res = num_blockers($ast, $btc->[0], $btc->[1]);
    assertEq("Blockers $btc->[0],$btc->[1]: ", $res, $btc->[2]);
  }
  my @test_cases =
    (
     [ [".#..#",
        ".....",
        "#####",
        "....#",
        "...##"], "3!4", 8 ],
     [ ["......#.#.",
        "#..#.#....",
        "..#######.",
        ".#.#.###..",
        ".#..#.....",
        "..#....#.#",
        "#..#....#.",
        ".##.#..###",
        "##...#..#.",
        ".#....####"], "5!8", 33 ],
     [ ["#.#...#.#.",
        ".###....#.",
        ".#....#...",
        "##.#.#.#.#",
        "....#.#.#.",
        ".##..###.#",
        "..#...##..",
        "..##....##",
        "......#...",
        ".####.###."], "1!2", 35 ],
     [ [".#..#..###",
         "####.###.#",
         "....###.#.",
         "..###.##.#",
         "##.##.#.#.",
         "....###..#",
         "..#.#..#.#",
         "#..#.#.###",
         ".##...##.#",
         ".....#.#.."], "6!3", 41 ],
     [ [".#..##.###...#######",
        "##.############..##.",
        ".#.######.########.#",
        ".###.#######.####.#.",
        "#####.##.#.##.###.##",
        "..#####..#.#########",
        "####################",
        "#.####....###.#.#.##",
        "##.#################",
        "#####.##.###..####..",
        "..######..##.#######",
        "####.##.####...##..#",
        ".#####..#.######.###",
        "##...#.##########...",
        "#.##########.#######",
        ".####.#.###.###.#.##",
        "....##.##.###..#####",
        ".#.#.###########.###",
        "#.#.#.#####.####.###",
        "###.##.####.##.#..##"], "11!13", 210 ]
    );
  for my $tc (@test_cases) {
    my $a = parse_input($tc->[0]);
    my $res = calc($a);
    print "Test 1 [@{$tc->[0]}] == @$res\n" if DEBUG;
    assertEq("Test 1 [@{$tc->[0]}]", $a->{best}, $tc->[1]);
    assertEq("Test 1 [@{$tc->[0]}]", $res, $tc->[2]);
  }
}

print "Part 1: ", calc($i), "\n";

sub angle {
  my ($a1,$a2) = @_;
  my ($x1,$y1) = @{kh($a1)};
  my ($x2,$y2) = @{kh($a2)};
  my $a = atan2($x2-$x1, $y1-$y2);
  while ($a<0) { $a += 3.14159265358979*2; }
  return $a;
}

sub calc2 {
  my ($astro, $num) = @_;
  my $nth = (map { $_->[0] }
             sort { $a->[1] <=> $b->[1] }
             map {
               [ $_,
                 (angle($astro->{best}, $_) +
                  (num_blockers($astro, $astro->{best}, $_) *
                   3.14159265358979 * 2))
               ]
             } grep $astro->{best} ne $_, keys %{$astro->{m}})[$num-1];
  my ($x, $y) = @{kh($nth//"-1!-1")};
  return $x*100+$y;
}

if (TEST) {
  for my $tc (["2!2", "2!0", 0.0],                # n
              ["2!2", "4!0", 0.7853981633974483], # ne
              ["2!2", "4!2", 1.5707963267948966], # e
              ["2!2", "4!4", 2.356194490192345],  # se
              ["2!2", "2!4", 3.141592653589793],  # s
              ["2!2", "0!4", 3.9269908169872414], # sw
              ["2!2", "0!2", 4.71238898038468],   # w
              ["2!2", "0!0", 5.49778714378213]) { # nw
    my $angle = angle($tc->[0], $tc->[1]);
    assertEq("Test Angle $tc->[0] => $tc->[1]", $angle, $tc->[2]);
  }

  my $a = parse_input([".#....#####...#..",
                       "##...##.#####..##",
                       "##...#...#.#####.",
                       "..#.....X...###..",
                       "..#.#.....#....##"]);
  assertEq("Test Part2 Best", $a->{best}, '8!3');
  my @order = (801, 900, 901, 1000, 902, 1101, 1201, 1102, 1501);
  for my $i (0..$#order) {
    assertEq("Test Part2 $i", calc2($a, $i + 1), $order[$i]);
  }
}

print "Part 2: ", calc2($i, 200), "\n";
