#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp(@*ARGS[0] // "input.txt");

my %CS1 = <1 2 3 4 5 6 7 8 9 T J Q K A>.antipairs;
my %CS2 = <J 1 2 3 4 5 6 7 8 9 T Q K A>.antipairs;

RunTests(sub { calc(@_) }) if %*ENV{"AoC_TEST"};

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  ((.cache.sort({.[1]}).kv.map: -> $i, $r { $r.[0]*($i+1) }).sum,
   (.cache.sort({.[2]}).kv.map: -> $i, $r { $r.[0]*($i+1) }).sum)
  given $in.lines.map({.split(' ')}).map: -> ($c, $bid) {
    # list of pairs of 'count => card'
    my @c = $c.comb.Bag.invert.sort.reverse;
    # add dummy entry to make sure there are always two
    push @c, 0 => 'J';
    # replace most common non-J if possible
    my $wild = @c[0].value eq 'J' ?? @c[1].value !! @c[0].value;
    # same for part 2
    my @d = $c.subst('J', $wild, :g).comb.Bag.invert.sort.reverse;
    push @d, 0 => 'J';
    # scores are numbers of the form:
    #   <best-count><second-best-count-or-zero><the-%02d-format-card-scores>
    [
     $bid,
     (@c[0].key*10+@c[1].key)~($c.comb.map: { sprintf "%02d", %CS1{$_} }).join(""),
     (@d[0].key*10+@d[1].key)~($c.comb.map: { sprintf "%02d", %CS2{$_} }).join(""),
    ]
  };
}
