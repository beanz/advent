#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp(@*ARGS[0] // "input.txt");

RunTests(sub { calc(@_) }) if %*ENV{"AoC_TEST"};

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub rot(@g) {
  my @n;
  for (0..(@g[0].chars-1)) -> $i {
    my $l = join('', map { substr($_, $i, 1) }, @g.reverse);
    $l = join('#', map { .split('').sort.join('') }, $l.split('#')); 
    @n.push($l);
  }
  return @n
}

sub calc ($in) {
  my @g = $in.lines;
  my @n = rot(@g);
  my $p1 = (@n.map: -> $l {
    ($l.indices('O').map: -> $i { $i+1; }).sum
  }).sum;
  my $tar = 1000000000;
  my $c = 1;
  my %seen;
  while $c ≤ $tar {
    @n = rot(@n);
    @n = rot(@n);
    @n = rot(@n);
    my $k = @n.join("!");
    #say @n.join("\n");
    #say $c, ": ", $p2, "\n";
    if %seen{$k}:exists {
      my $l = $c - %seen{$k};
      my $jump = ($tar - $c) div $l;
      $c += $jump × $l;
      %seen = ();
    }
    %seen{$k} = $c;
    $c++;
    @n = rot(@n);
  }
  my $p2 = (@n.kv.map: -> $i, $l { (@n-$i)*($l.indices('O').elems) }).sum;
  ($p1, $p2)
}
