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

sub input {
  my ($hull) = @_;
  #printf("reading %d from [%d,%d]\n", ($hull->{m}->{hk($hull->{x},$hull->{y})} // 0), $hull->{x},$hull->{y});
  return $hull->{m}->{hk($hull->{x},$hull->{y})} // 0;
}

sub output {
  my ($hull, $val) = @_;
  #printf("writing %d to [%d,%d]\n", $val, $hull->{x},$hull->{y});
  $hull->{m}->{hk($hull->{x},$hull->{y})} = $val;
}

sub process_output {
  my ($hull, $ic) = @_;
  my $col = shift @{$ic->{o}};
  my $turn = shift @{$ic->{o}};
  output($hull, $col);
  #printf("col: %d turn: %d\n", $col, $turn);
  #printf("  d[%d, %d] => ", $hull->{dir}->[X], $hull->{dir}->[Y]);
  $hull->{dir} =
    $turn ? offsetCW(@{$hull->{dir}}) : offsetCCW(@{$hull->{dir}});
  #printf(" d[%d, %d]\n", $hull->{dir}->[X], $hull->{dir}->[Y]);
  #printf("  p(%d, %d) => ", $hull->{x}, $hull->{y});
  $hull->{x} += $hull->{dir}->[X];
  $hull->{y} += $hull->{dir}->[Y];
  #printf(" p(%d, %d)\n", $hull->{x}, $hull->{y});
  #printf(" size=%d\n", scalar keys %{$hull->{m}});
  minmax_xy($hull->{bb}, $hull->{x}, $hull->{y});
  return 1;
}

sub run {
  my ($prog, $hull, $input) = @_;
  my $ic = IntCode->new($prog, [$input]);
  my @out;
  while (!$ic->{done}) {
    my $rc = $ic->run();
    if (@{$ic->{o}} == 2) {
      process_output($hull, $ic);
      #printf(" i: %d\n", input($hull));
      push @{$ic->{i}}, input($hull);
    }
  }
  return $hull;
}

sub calc {
  my ($prog) = @_;
  my $hull = run($prog, { x => 0, y => 0,
                      dir => compassOffset('N'),
                          m => {}, bb => [] }, 0);
  return scalar keys %{$hull->{m}};
}

sub calc2 {
  my ($prog) = @_;
  my $hull = run($prog, { x => 0, y => 0,
                          dir => compassOffset('N'),
                          m => {}, bb => [] }, 1);
  my $s = "";
  for my $y ($hull->{bb}->[MINY] .. $hull->{bb}->[MAXY]) {
    for my $x ($hull->{bb}->[MINX] .. $hull->{bb}->[MAXX]) {
      $s .= $hull->{m}->{hk($x,$y)} ? '#' : '.';
    }
    $s .= "\n";
  }
  return $s;
}

print "Part 1: ", calc($i), "\n";
print "Part 2:\n", calc2($i), "\n";
