#!/usr/bin/env raku

my $input = slurp (@*ARGS[0]//"input.txt");

if %*ENV{"AoC_TEST"} {
  my ($p1, $p2) = parts(slurp("test1.txt"));
  assert_eq(4361, $p1);
  assert_eq(467835, $p2);
  ($p1, $p2) = parts(slurp("input.txt"));
  assert_eq(549908, $p1);
  assert_eq(81166799, $p2);
}

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

sub assert_eq($exp, $actual) {
  if $actual == $exp {
    say "  test {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "expected {$exp}; got {$actual}";
}
