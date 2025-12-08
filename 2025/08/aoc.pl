#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_2024;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my $p2 = 0;
  my $conns = @$in > 20 ? 1000 : 10;
  my %m;
  for my $i (0 .. @$in - 1) {
    for my $j ($i + 1 .. @$in - 1) {
      my $d =
        sqrt(($in->[$i]->[0] - $in->[$j]->[0])**2 +
          ($in->[$i]->[1] - $in->[$j]->[1])**2 +
          ($in->[$i]->[2] - $in->[$j]->[2])**2);
      $m{$d} = [$i, $j];
    }
  }
  my @dist = sort {$b <=> $a} keys %m;
  my %n;
  my %c;
  my $cn = 0;
  my $count = 0;
  my $todo = @$in;

  while (1) {
    my $c = $m{pop @dist};
    my ($aa, $bb) = @$c;
    if (exists $n{$aa} && exists $n{$bb}) {
      my $new = $n{$aa};
      my $old = $n{$bb};
      if ($new != $old) {
        for my $o (@{$c{$old}}) {
          push @{$c{$new}}, $o;
          $n{$o} = $new;
        }
        delete $c{$old};
      }
    } elsif (exists $n{$aa}) {
      my $new = $n{$aa};
      $n{$bb} = $new;
      push @{$c{$new}}, $bb;
      $todo--;
    } elsif (exists $n{$bb}) {
      my $new = $n{$bb};
      $n{$aa} = $new;
      push @{$c{$new}}, $aa;
      $todo--;
    } else {
      my $new = $cn;
      $cn++;
      $n{$aa} = $new;
      $n{$bb} = $new;
      $todo -= 2;
      push @{$c{$new}}, $aa, $bb;
    }
    $count++;
    if ($todo == 0) {
      $p2 = $in->[$aa]->[0] * $in->[$bb]->[0];
      last;
    }
    if ($count == $conns) {
      my @cs = sort {@{$c{$b}} <=> @{$c{$a}}} keys %c;
      $p1 = @{$c{$cs[0]}} * @{$c{$cs[1]}} * @{$c{$cs[2]}};
    }
  }

  return [$p1, $p2];
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
