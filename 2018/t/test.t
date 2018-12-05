#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

sub run {
  my ($script, $input) = @_;
  open my $fh, "-|", $^X, $script, $input or return "error $!";
  my $c;
  {
    local $/;
    $c = <$fh>;
  }
  chomp $c;
  close $fh;
  return $c;
}

for (
     [qw{01/a.pl 01/test.txt 3}],
     [qw{01/a.pl 01/input.txt 505}],
     [qw{01/b.pl 01/test.txt 2}],
     [qw{01/b.pl 01/input.txt 72330}],
     [qw{02/a.pl 02/test-1.txt 12}],
     [qw{02/a.pl 02/input.txt 9633}],
     [qw{02/b.pl 02/test-2.txt fgij}],
     [qw{02/b.pl 02/input.txt lujnogabetpmsydyfcovzixaw}],
     [qw{03/a.pl 03/test.txt 4}],
     [qw{03/a.pl 03/input.txt 106501}],
     [qw{03/b.pl 03/test.txt 3}],
     [qw{03/b.pl 03/input.txt 632}],
     [qw{04/a.pl 04/test.txt 240}],
     [qw{04/a.pl 04/input.txt 71748}],
     [qw{04/b.pl 04/test.txt 4455}],
     [qw{04/b.pl 04/input.txt 106850}],
     [qw{05/a.pl 05/test.txt 10}],
     [qw{05/a.pl 05/input.txt 11264}],
     [qw{05/b.pl 05/test.txt 4}],
     [qw{05/b.pl 05/input.txt 4552}],
    ) {
  my ($script, $input, $res) = @$_;
  is(run($script, $input), $res, $script.' '.$input);
}

done_testing();
