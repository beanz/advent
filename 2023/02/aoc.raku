#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp (@*ARGS[0]//"input.txt");

RunTests(sub { parts(@_) }) if %*ENV{"AoC_TEST"};

my ($p1, $p2) = parts($input);
say "Part 1: ", $p1;
say "Part 2: ", $p2;

sub parts($in) {
  [Z+] $in.lines>>.substr(5)>>.split(': ').map: -> ($id, $sets) {
    my @m = ([Zmax] .map(*<red green blue>)) given |$sets.split('; ').map(*.comb(/\w+/).reverse.pairup.Bag);
    ($id * so (for @m.kv -> $i, $_ { $_ <= 12+$i}).all, [*] @m)
  }
}
