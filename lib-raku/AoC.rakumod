unit module AoC;


sub RunTests($fn) is export {
  my $c = slurp('TC.txt') or die "no test case file: $!\n";
  chomp $c;
  my @tc;
  for ($c.split("\n---END---\n")) -> $l {
    my ($args, $p1, $p2) = $l.split("\n");
    my @a = $args.split(/\s/);
    my $f = @a.shift;
    my @res = $fn.(slurp($f), |@a);
    assert_eq($p1, @res[0], "part 1: $args");
    assert_eq($p2, @res[1], "part 2: $args");
  }
}

sub assert_eq($exp, $actual, $msg) is export {
  if $actual eq $exp {
    say "  test $msg: {$exp} == {$actual}" if %*ENV{"AoC_TEST"} > 1;
    return;
  }
  die "$msg: expected {$exp}; got {$actual}";
}
