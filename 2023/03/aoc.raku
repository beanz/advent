#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp (@*ARGS[0]//"input.txt");

RunTests(sub { parts(|@_) }) if %*ENV{"AoC_TEST"};

my ($p1, $p2) = parts($input);
say "Part 1: ", $p1;
say "Part 2: ", $p2;

sub parts($in) {
  my $w = $in.index("\n")+1;
  my $symbols = $in.comb.kv.grep: -> $i, $ch {is_symbol($ch)};
  my %s; # map of symbol indexes to list of neighbouring numbers
  for numbers($in) -> ($i, $n) {
    my ($nb, $sym) = neighbours($in, $i, $n.chars, $w).first;
    %s{$nb}.push($n) if $($nb);
  }
  [Z+] %s.values.map: -> @n { (([+] @n), (@n.elems == 2 ?? ([*] @n) !! 0 ))}
}

# returns list of [index, number] for all numbers found
sub numbers($in) {
  my @numbers;
  $in ~~ m:g/(\d+){@numbers.push([$/.pos-$0.chars, $0])}/;
  @numbers;
}

# returns list of [index, symbol] for neighbouring symbols
sub neighbours($in, $i, $l, $w) {
  my @p = (|($i-$w-1..$i-$w+$l), $i-1, $i+$l, |($i+$w-1..$i+$w+$l)).grep({$_>=0 && $_ < $in.chars}).map({[$_, $in.substr($_, 1)]}).grep({ is_symbol($_[1])});
  @p
}

sub is_symbol($ch) {
  $ch ne '.' && $ch ne "\n" && !('0' ge $ch && $ch ge '9')
}
