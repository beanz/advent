#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp (@*ARGS[0]//"input.txt");

my %num;
my $n = 1;
for 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine' -> $s {
  %num{$s} = $n;
  %num{$n} = $n;
  $n++;
}

my $p2 = rx/(\d|one|two|three|four|five|six|seven|eight|nine)/;

RunTests(sub { [calc(@_, /\d/), calc(@_, $p2)] }) if %*ENV{"AoC_TEST"};

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
