#!/usr/bin/env raku

my $input = slurp (@*ARGS[0]//"input.txt");

my %num;
my $n = 1;
for 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine' -> $s {
  %num{$s} = $n;
  %num{$n} = $n;
  $n++;
}

my $p2 = rx/(\d|one|two|three|four|five|six|seven|eight|nine)/;
if %*ENV{"AoC_TEST"} {
  assert_eq(142, calc(slurp("test1.txt"), /\d/));
  assert_eq(54390, calc(slurp("input.txt"), /\d/));
  assert_eq(281, calc(slurp("test2.txt"), $p2));
  assert_eq(54277, calc(slurp("input.txt"), $p2));
}

say "Part 1: ", calc($input, /\d/);
say "Part 2: ", calc($input, $p2); 

sub calc($in, $pattern) {
   return $in.lines.map({
     if my @n = .match($pattern, :g, :ov) {
       %num{@n[0]}*10+%num{@n[*-1]}
     } else {
       0
     }
   }).sum;
}

sub assert_eq($exp, $actual) {
  if $actual == $exp {
    say "  test {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "expected {$exp}; got {$actual}";
}
