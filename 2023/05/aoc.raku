#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp (@*ARGS[0]//"input.txt");

RunTests(sub { calc(|@_) }) if %*ENV{"AoC_TEST"};

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
