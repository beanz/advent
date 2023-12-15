#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp(@*ARGS[0] // "input.txt");

RunTests(sub { calc(@_) }) if %*ENV{"AoC_TEST"};

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  my @g = $in.lines.split(',');
  my $p1 = 0;
  my @b = [] xx 256;
  for @g -> $l {
    $p1 += hash($l);
    my ($lb, $op, $v) = $l.match(/^(.*)('-'|'=')(\d*)$/).map(~*);
    my $bn = hash($lb);
    my $fi;
    for @b[$bn].kv -> $i, $b {
      if $b.[0] eq $lb {
        $fi = $i;
        last;
      }
    }
    if $op eq '-' {
        (@b[$bn]).splice($fi, 1) if (defined $fi);
    } else {
      if (defined $fi) {
        @b[$bn].[$fi].[1] = $v;
      } else {
        @b[$bn].push([$lb, $v]);
      }
    }
  }
  ($p1, (@b.kv.map: -> $bn, $bl {
    ($bn + 1) * ($bl.kv.map: -> $sn, $b {
      ($sn + 1) * $b.[1]
    }).sum
  }).sum)
}

sub hash($s) {
  reduce { (($^a + $^b.ord) × 17) % 256 }, 0, |$s.comb
}
