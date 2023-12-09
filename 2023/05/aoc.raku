#!/usr/bin/env raku

my $input = slurp(@*ARGS[0] // "input.txt");

if %*ENV{"AoC_TEST"} {
  assert_eq((35, 46), calc(slurp("test1.txt")));
  assert_eq((535088217, 51399228), calc(slurp("input.txt")));
}

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  my @ch = $in.split(/\n\n/);
  my @seeds = @ch.shift.comb(/\d+/);
  my @ranges = @seeds.pairup.map: { .key => .key + .value };
  my @maps = @ch.map: { .lines.skip(1).map: { .comb(/\d+/)} };
  for @maps -> @map {
    my @n = @seeds.map: -> $seed {
      my $n = $seed;
      for @map -> [$dst, $src, $len] {
        if $src ≤ $seed && $seed < $src + $len {
          $n = $dst + $seed - $src;
          last;
        }
      }
      $n;
    };
    @seeds = @n;
  }

  (@seeds.min, 2)
}

sub assert_eq ($exp, $actual) {
  if $actual eq $exp {
    say "  test {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "expected {$exp}; got {$actual}";
}

