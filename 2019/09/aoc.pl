#!/usr/bin/perl
use warnings;# FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use IntCode;
use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/permutations/;

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub run {
  my ($prog, $input) = @_;
  my $ic = IntCode->new($prog, [$input]);
  my @out;
  while (!$ic->{done}) {
    my $rc = $ic->run();
    my $out = shift @{$ic->{o}};
    push @out, $out if (defined $out);
  }
  return \@out;
}

sub calc {
  my ($prog) = @_;
  return run($prog, 1)->[0];
}

sub calc2 {
  my ($prog) = @_;
  return run($prog, 2)->[0];
}

if (TEST) {

  for my $tc ([["109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"],
               "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"],
              [["1102,34915192,34915192,7,4,7,99,0"], "1219070632396864"],
              [["104,1125899906842624,99"], "1125899906842624"],
             ) {
    my $ti = parse_input($tc->[0]);
    my $o = run($ti,1);
    assertEq("Test 1 $tc->[0]->[0]: ", join(',',@{$o}), $tc->[1]);
  }
}

print "Part 1: ", calc($i), "\n";
print "Part 2: ", calc2($i), "\n";
