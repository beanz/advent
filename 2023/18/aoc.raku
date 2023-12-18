#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp(@*ARGS[0] // "input.txt");

RunTests(sub { calc(@_) }) if %*ENV{"AoC_TEST"};

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  (area(.map: {part1($_)}), area(.map: {part2($_)}))
  given ($in.lines.map: {.split(" ")}).cache;
}

sub area(@l) {
  my $a = 0;
  my $p = 0;
  my ($x, $y) = (0, 0);
  for @l -> ($n, $o) {
    my ($nx, $ny) = ($x+$n*$o.[0], $y+$n*$o.[1]);
    $a += ($x-$nx) × ($y+$ny);
    $p += $n;
    ($x, $y) = ($nx, $ny);
  }
  ($a.abs+$p+2)/2;
}

sub part1(@l) {
  @l[1], { R => (1,0), D => (0,1), L => (-1,0), U => (0,-1) }.{@l[0]}
}

sub part2(@l) {
  my $hx = substr @l[2], 2, 5;
  my $d = substr @l[2], 7, 1;
  my $n = :16($hx);
  $n, [ (1,0), (0,1), (-1,0), (0,-1) ].[$d]
}
