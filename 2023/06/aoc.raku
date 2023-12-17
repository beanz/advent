#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp (@*ARGS[0]//"input.txt");

RunTests(sub { parts(|@_) }) if %*ENV{"AoC_TEST"};

say "Part 1: ", .[0], "\nPart 2: ", .[1] given parts($input);

sub parts($in) {
  my @n = $in.lines.map: {.comb(/\d+/).Capture};
  my @p2 = @n.map(*.join);
  ( [*] (calc(@n[0][$_], @n[1][$_]) for 0..@n[0].elems-1)), calc |@p2
}

sub calc($t, $r) {
  my $d = ($t*$t - 4*($r+1)).sqrt;
  my $l = (($t-$d)/2).ceiling;
  my $h = (($t+$d)/2).floor;
  $h - $l + 1
}
