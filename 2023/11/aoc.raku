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
  my @cx = 0 xx $w;
  my @cy = 0 xx $h;
  my $gc = 0;
  my ($xmin, $xmax, $ymin, $ymax) = ($w,0,$h,0);
  for (0..$h-1) -> $y {
    for (0..$w-1) -> $x {
      if @g.[$y].[$x] ne '.' {
        @cx[$x]++;
        @cy[$y]++;
        $gc++;
        if $x < $xmin {
          $xmin = $x;
        }
        if $x > $xmax {
          $xmax = $x;
        }
      }
    }
    if (@cy[$y] > 0) {
      if $y < $ymin {
        $ymin = $y;
      }
      if $y > $ymax {
        $ymax = $y;
      }
    }
  }
  my ($dx1, $dx2) = dist($gc, $xmin, $xmax, @cx, $mul);
  my ($dy1, $dy2) = dist($gc, $ymin, $ymax, @cy, $mul);
  ($dx1+$dy1, $dx2+$dy2)
}

sub dist($gc, $min, $max, @v, $mul) {
  my ($exp1, $exp2) = (0,0);
  my ($d1, $d2) = (0,0);
  my $px = $min;
  my $nx = @v[$min];
  for ($min+1 .. $max) -> $x {
    if @v[$x] > 0 {
      $d1 += ($x - $px + $exp1) * $nx * ($gc-$nx);
      $d2 += ($x - $px + $exp2) * $nx * ($gc-$nx);
      $nx += @v[$x];
      $px = $x;
      ($exp1, $exp2) = (0,0);
    } else {
      $exp1 += 1;
      $exp2 += $mul-1;
    }
  }
  ($d1, $d2);
}
