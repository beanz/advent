#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp (@*ARGS[0]//"input.txt");

RunTests(sub { calc(|@_) }) if %*ENV{"AoC_TEST"};

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

