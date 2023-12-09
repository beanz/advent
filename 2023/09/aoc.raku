#!/usr/bin/env raku

my $input = slurp(@*ARGS[0] // "input.txt");

if %*ENV{"AoC_TEST"} {
  assert_eq((114, 2), calc(slurp("test1.txt")));
  assert_eq((1584748274, 1026), calc(slurp("input.txt")));
}

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  [Z+] $in.lines.map: -> $l {
    (solve($_), solve(.reverse)) given $l.split(/\s+/);
  }
}

sub solve(@n) {
  my @d = @n[1..@n.elems-1] Z- @n[0..(@n.elems-2)];
  @n.tail + (@d.all == 0 ?? @d.first !! solve(@d))
}

sub assert_eq ($exp, $actual) {
  if $actual eq $exp {
    say "  test {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "expected {$exp}; got {$actual}";
}

