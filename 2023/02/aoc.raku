#!/usr/bin/env raku

my $input = slurp (@*ARGS[0]//"input.txt");

if %*ENV{"AoC_TEST"} {
  my ($p1, $p2) = parts(slurp("test1.txt"));
  assert_eq(8, $p1);
  assert_eq(2286, $p2);
  ($p1, $p2) = parts(slurp("input.txt"));
  assert_eq(2101, $p1);
  assert_eq(58269, $p2);
}

my ($p1, $p2) = parts($input);
say "Part 1: ", $p1;
say "Part 2: ", $p2;

sub parts($in) {
  [Z+] $in.lines>>.substr(5)>>.split(': ').map: -> ($id, $sets) {
    my @m = ([Zmax] .map(*<red green blue>)) given |$sets.split('; ').map(*.comb(/\w+/).reverse.pairup.Bag);
    ($id * (@m[0] <= 12 && @m[1] <= 13 && @m[2] <= 14), [*] @m)
  }
}

sub assert_eq($exp, $actual) {
  if $actual == $exp {
    say "  test {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "expected {$exp}; got {$actual}";
}
