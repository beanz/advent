#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp (@*ARGS[0]//"input.txt");

RunTests(sub { parts(|@_) }) if %*ENV{"AoC_TEST"};

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
