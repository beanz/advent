#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp (@*ARGS[0]//"input.txt");

constant NORTH = 1;
constant SOUTH = 2;
constant EAST = 4;
constant WEST = 8;

RunTests(sub { calc(|@_) }) if %*ENV{"AoC_TEST"};

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  my $g = $in.lines.map: {.comb};
  my $w = $g[0].elems;
  my ($sx,$sy) = ($_%($w+1), ($_ div ($w+1))) given $in.index('S');
  my $from = (reduce {
    $^a.push($^b) if (dirs($g, |move($sx, $sy, $^b)) ∋ opposite($^b));
    $^a
  }, [], NORTH, SOUTH, EAST, WEST).first;
  my ($x, $y) = move($sx, $sy, $from);
  my $p1 = 1;
  my $A = ($x-$sx)*($y+$sy);
  until ($x == $sx && $y == $sy) {
    my $step = ((opposite($from) ⊖ dirs($g, $x, $y)).keys.first);
    my ($nx, $ny) = move($x, $y, $step);
    $A += ($nx-$x)*($ny+$y);
    ($x, $y) = ($nx, $ny);
    $from = $step;
    $p1++;
  } 
  $p1 div= 2;
  ($p1, ($A.abs div 2)-$p1+1);
}

sub move($x, $y, $d) {
  given $d {
    when NORTH { [$x,$y-1] };
    when SOUTH { [$x,$y+1] };
    when EAST { [$x+1,$y] };
    when WEST { [$x-1,$y] };
  }
}

sub opposite($d) {
  given $d {
    when NORTH { SOUTH }
    when SOUTH { NORTH }
    when EAST { WEST }
    when WEST { EAST }
  }
}

sub dirs($g, $x, $y) {
  if ($x < 0 || $y < 0 || $x >= $g[0].elems || $y >= $g.elems) {
    return [];
  }
  given $g[$y][$x] {
    when '|' { [NORTH,SOUTH] }
    when '-' { [EAST,WEST] }
    when 'L' { [NORTH,EAST] }
    when 'J' { [NORTH,WEST] }
    when '7' { [SOUTH,WEST] }
    when 'F' { [SOUTH,EAST] }
    default { [] }
  }
}
