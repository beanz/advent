#!/usr/bin/env raku

my $input = slurp(@*ARGS[0] // "input.txt");

if %*ENV{"AoC_TEST"} {
  assert_eq((4, 1), calc(slurp("test1.txt")));
  assert_eq((8, 1), calc(slurp("test2.txt")));
  assert_eq((23, 4), calc(slurp("test3.txt")));
  assert_eq((70, 8), calc(slurp("test4.txt")));
  assert_eq((80, 10), calc(slurp("test5.txt")));
  assert_eq((7086, 317), calc(slurp("input.txt")));
}

constant NORTH = 1;
constant SOUTH = 2;
constant EAST = 4;
constant WEST = 8;

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  my $g = $in.lines.map: {.comb};
  my $h = $g.elems;
  my $w = $g[0].elems;
  my ($sx,$sy) = ($_%($w+1), ($_/($w+1)).floor) given $in.index('S');
  my $sd = [];
  if (dirs($g, $sx, $sy-1) ∋ SOUTH) {
    $sd.push(NORTH);
  }
  if (dirs($g, $sx, $sy+1) ∋ NORTH) {
    $sd.push(SOUTH);
  }
  if (dirs($g, $sx-1, $sy) ∋ EAST) {
    $sd.push(WEST);
  }
  if (dirs($g, $sx+1, $sy) ∋ WEST) {
    $sd.push(EAST);
  }
  my $from = $sd.first;
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

  my $l = 0;
  my $p2 = ($A.abs div 2)-($p1 div 2)+1;
  ($p1/2, $p2)
}

sub move($x,$y,$d) {
  given $d {
    when NORTH { [$x,$y-1] };
    when SOUTH { [$x,$y+1] };
    when EAST { [$x+1,$y] };
    when WEST { [$x-1,$y] };
  }
}

sub step($g, $x, $y, $not) {
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

sub assert_eq ($exp, $actual) {
  if $actual eq $exp {
    say "  test {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "expected {$exp}; got {$actual}";
}

