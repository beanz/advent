#!/usr/bin/env raku

my $input = slurp(@*ARGS[0] // "input.txt");

if %*ENV{"AoC_TEST"} {
  assert_eq((2, 2), calc(slurp("test1.txt")));
  assert_eq((6, 6), calc(slurp("test2.txt")));
  assert_eq((1, 6), calc(slurp("test3.txt")));
  assert_eq((20569, 21366921060721), calc(slurp("input.txt")));
}

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  my ($s, $o, @l) = $in.lines;
  my @steps = $s.comb;
  my %l; my @g;
  for @l {
    my ($f, @m) = .comb(/\w+/);
    %l{$f} = @m;
    @g.push($f) if ($f ~~ /^<-[A]>+A$/);
  }
  my $mod = @steps.elems;
  sub run ($start) {
    my $p = $start;
    my $c = 0;
    loop {
      if @steps[$c % $mod] eq 'L' {
        $p = %l{$p}.[0];
      } else {
        $p = %l{$p}.[1];
      }
      $c++;
      return $c unless (defined $p);
      return $c if ($p ~~ /Z$/);
    }
  }
  my $p1 = run('AAA');
  my $p2 = reduce {$^a lcm run($^b)}, $p1, | @g;
  $p1, $p2;
}

sub assert_eq ($exp, $actual) {
  if $actual eq $exp {
    say "  test {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "expected {$exp}; got {$actual}";
}

