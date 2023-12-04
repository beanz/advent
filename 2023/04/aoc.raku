#!/usr/bin/env raku

my $input = slurp (@*ARGS[0]//"input.txt");

if %*ENV{"AoC_TEST"} {
  my ($p1, $p2) = parts(slurp("test1.txt"));
  assert_eq(13, $p1);
  assert_eq(30, $p2);
  ($p1, $p2) = parts(slurp("input.txt"));
  assert_eq(25183, $p1);
  assert_eq(5667240, $p2);
}

my ($p1, $p2) = parts($input);
say "Part 1: ", $p1;
say "Part 2: ", $p2;

sub parts($in) {
  ([0,0,()], |($in.lines>>.split('|').map: -> ($w, $n) {
    (($w.comb(/\d+/)[1..*].Set) ∩ ($n.comb(/\d+/).Set)).elems
  })).reduce: -> [$ap1,$ap2,@copies], $matches {
    my $n = 1 + [+] @copies.map({ .[1] });
    my @nc = @copies.map({ (.[0]-1, .[1] ) }).grep: { .[0] > 0 };
    if $matches > 0 {
      @nc.push([$matches, $n]);
    }
    [$ap1 + ((1+<$matches)+>1), $ap2+$n, @nc]
  };
}

sub assert_eq($exp, $actual) {
  if $actual == $exp {
    say "  test {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "expected {$exp}; got {$actual}";
}
