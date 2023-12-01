#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use IntCode;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub calc {
  my ($prog) = @_;
  my @c = ();
  for my $i (0..49) {
    my $ic = IntCode->new($prog, [$i]);
    push @c, $ic;
    $ic->{name} = $i;
    #$ic->{run_one} = 1;
    #push @{$c[$i]->{i}}, $i;
  }
  while (1) {
    for my $i (0..49) {
      next if ($c[$i]->{done});
      my $rc = $c[$i]->run();
      if ($rc == 2) {
        #print "@{$c[$i]->{i}}\n";
        #print "$i: no input sending -1\n";
        push @{$c[$i]->{i}}, -1;
      } elsif ($rc == 0) {
        if (@{$c[$i]->{o}} >= 3) {
          my ($a, $x, $y) = splice @{$c[$i]->{o}}, 0, 3;
          #print "$i: received $a, $x, $y\n";
          if ($a == 255) {
            return $y;
          } elsif ($a < 50) {
            push @{$c[$a]->{i}}, $x, $y;
            #print "sent ", $a, " < ", $x, ",", $y, "\n";
          }
        }
      }
    }
  }
  return -1;
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($prog) = @_;
  my @c = ();
  for my $i (0..49) {
    my $ic = IntCode->new($prog, [$i]);
    push @c, $ic;
    $ic->{name} = $i;
    #push @{$c[$i]->{i}}, $i;
  }
  my $last = 0;
  my $nat = undef;
  my $count = 0;
  while (1) {
    my $idle = 0;
    for my $i (0..49) {
      next if ($c[$i]->{done});
      my $rc = $c[$i]->run();
      if ($rc == 2) {
        #print "@{$c[$i]->{i}}\n";
        #print "$i: no input sending -1\n";
        push @{$c[$i]->{i}}, -1;
        $idle++;
      } elsif ($rc == 0) {
        if (@{$c[$i]->{o}} >= 3) {
          my ($a, $x, $y) = splice @{$c[$i]->{o}}, 0, 3;
          #print "$i: received $a, $x, $y\n";
          if ($a == 255) {
            $nat = [$x,$y];
          } elsif ($a < 50) {
            push @{$c[$a]->{i}}, $x, $y;
            #print "sent ", $a, " < ", $x, ",", $y, "\n";
          }
        }
      }
    }
    if ($idle == 50 && $count++ > 2) {
      #print "nat 0 < ", $nat->[0], ",", $nat->[1], "\n";
      if ($nat->[1] == $last) {
        return $nat->[1];
      }
      $last = $nat->[1];
      push @{$c[0]->{i}}, @$nat;
      $count = 0;
    }
  }
  return -1;
}

$i = parse_input(\@i);
print "Part 2: ", calc2($i), "\n";
