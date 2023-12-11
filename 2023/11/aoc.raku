#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp(@*ARGS[0] // "input.txt");

RunTests(sub { calc(@_) }) if %*ENV{"AoC_TEST"};

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc {
  my ($in, $mul)  = @_;
  $mul //= 1000000;
  my @g = $in.lines.map: {.comb};
  my $w = @g[0].elems;
  my $h = @g.elems;
  my %c = X => {}, Y => {};
  for (0..$h-1) -> $y {
    for (0..$w-1) -> $x {
      if @g.[$y].[$x] ne '.' {
        %c{'Y'}.{$y}++;
        last;
      }
    }
  }
  for (0..$w-1) -> $x {
    for (0..$h-1) -> $y {
      if @g.[$y].[$x] ne '.' {
        %c{'X'}.{$x}++;
        last;
      }
    }
  }
  my ($ax, $ay) = (0,0);
  my ($ax2, $ay2) = (0,0);
  my @g1;
  my @g2;
  for (0..$h-1) -> $y {
    for (0..$w-1) -> $x {
      if @g.[$y].[$x] ne '.' {
        @g1.push([$ax, $ay]);
        @g2.push([$ax2, $ay2]);
      }
      $ax += 1;
      $ax2 += 1;
      if !%c{'X'}.{$x} {
        $ax += 1;
        $ax2 += $mul - 1;
      }
    }
    $ax = $ax2 = 0;
    $ay += 1;
    $ay2 += 1;
    if !%c{'Y'}.{$y} {
      $ay += 1;
      $ay2 += $mul - 1;
    }
  }

  my ($p1, $p2) = 0, 0;
  for (0..@g1.elems-1) -> $i {
    for ($i+1 .. @g1.elems-1) -> $j {
      $p1 += abs(@g1[$i][0]-@g1[$j][0]) + abs(@g1[$i][1]-@g1[$j][1]);
      $p2 += abs(@g2[$i][0]-@g2[$j][0]) + abs(@g2[$i][1]-@g2[$j][1]);
    }
  }
  ($p1, $p2)
}
