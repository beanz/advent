#!/usr/bin/env raku

my $input = slurp (@*ARGS[0]//"input.txt");

if %*ENV{"AoC_TEST"} {
  my ($p1, $p2) = parts(slurp("test1.txt"));
  assert_eq(288, $p1);
  assert_eq(71503, $p2);
  ($p1, $p2) = parts(slurp("input.txt"));
  assert_eq(5133600, $p1);
  assert_eq(40651271, $p2);
}

my ($p1, $p2) = parts($input);
say "Part 1: ", $p1;
say "Part 2: ", $p2;

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

sub assert_eq($exp, $actual) {
  if $actual == $exp {
    say "  test {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "expected {$exp}; got {$actual}";
}
