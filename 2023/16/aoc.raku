#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp(@*ARGS[0] // "input.txt");

RunTests(sub { calc(@_) }) if %*ENV{"AoC_TEST"};

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  my @g = $in.lines.map: {.comb};
  my %m = g => @g, w => @g[0].elems, h => @g.elems;
  my $p2a = max(map { max(solve(%m, $_, 0, 'v'),solve(%m, $_, %m<h>-1, '^')) },0..^%m<w>);
  my $p2b = max(map { max(solve(%m, 0, $_, '>'),solve(%m, %m<w>-1, $_, '<')) },0..^%m<h>);
  (solve(%m, 0, 0, '>'), max($p2a, $p2b))
}

sub solve(%m, $x, $y, $d) {
  my %seen;
  my @todo;
  @todo.push([$x,$y,$d]);
  while @todo.elems > 0 {
    my $cur = @todo.shift;
    my ($x, $y, $d) = $cur;
    next if ($x < 0 || $x >= %m<w> || $y < 0 || $y >= %m<h>);
    next if %seen{"$x,$y"}.{$d}:exists;
    %seen{"$x,$y"}.{$d}++;
    given (%m<g>.[$y].[$x], $d) {
      when ('.', '^') { @todo.push([$x, $y-1, $d]) };
      when ('.', 'v') { @todo.push([$x, $y+1, $d]) };
      when ('.', '>') { @todo.push([$x+1, $y, $d]) };
      when ('.', '<') { @todo.push([$x-1, $y, $d]) };
      when ('-', '^') { @todo.push([$x-1, $y, '<'], [$x+1, $y, '>']) };
      when ('-', 'v') { @todo.push([$x-1, $y, '<'], [$x+1, $y, '>']) };
      when ('-', '>') { @todo.push([$x+1, $y, $d]) };
      when ('-', '<') { @todo.push([$x-1, $y, $d]) };
      when ('|', '^') { @todo.push([$x, $y-1, $d]) };
      when ('|', 'v') { @todo.push([$x, $y+1, $d]) };
      when ('|', '>') { @todo.push([$x, $y-1, '^'], [$x, $y+1, 'v']) };
      when ('|', '<') { @todo.push([$x, $y-1, '^'], [$x, $y+1, 'v']) };
      when ('/', '^') { @todo.push([$x+1, $y, '>']) };
      when ('/', 'v') { @todo.push([$x-1, $y, '<']) };
      when ('/', '>') { @todo.push([$x, $y-1, '^']) };
      when ('/', '<') { @todo.push([$x, $y+1, 'v']) };
      when ('\\', '^') { @todo.push([$x-1, $y, '<']) };
      when ('\\', 'v') { @todo.push([$x+1, $y, '>']) };
      when ('\\', '>') { @todo.push([$x, $y+1, 'v']) };
      when ('\\', '<') { @todo.push([$x, $y-1, '^']) };
    }
  }
  return %seen.elems;
}
