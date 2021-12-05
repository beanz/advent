#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use IntCode;
use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/permutations/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub calc {
  my ($prog, $input) = @_;
  my $ic = IntCode->new($prog, [0]);
  my $block;
  while (!$ic->{done}) {
    my $rc = $ic->run();
    if (@{$ic->{o}} == 3) {
      my $x = shift @{$ic->{o}};
      my $y = shift @{$ic->{o}};
      my $t = shift @{$ic->{o}};
      $block++ if ($t == 2);
    }
  }
  return $block;
}

sub calc2 {
  my ($prog) = @_;
  $prog->[0] = 2;
  my $arcade = { ball => 0, pad => 0, score => 0 };
  my $ic = IntCode->new($prog, []);
  while (!$ic->{done}) {
    my $rc = $ic->run();
    if ($rc == 2) {
      push @{$ic->{i}}, $arcade->{ball} <=> $arcade->{paddle};
      next;
    }
    if (@{$ic->{o}} == 3) {
      my $x = shift @{$ic->{o}};
      my $y = shift @{$ic->{o}};
      my $t = shift @{$ic->{o}};
      if ($x == -1 && $y == 0) {
        $arcade->{score} = $t;
      } elsif ($t == 3) {
        $arcade->{paddle} = $x;
      } elsif ($t == 4) {
        $arcade->{ball} = $x;
      }
    }
  }
  return $arcade->{score};
}

print "Part 1: ", calc($i), "\n";
$i = parse_input(\@i);
print "Part 2: ", calc2($i), "\n";
