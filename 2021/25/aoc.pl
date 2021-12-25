#!/usr/bin/perl
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
my $reader = \&read_stuff;
my $i = $reader->($file);

sub read_stuff {
  my $file = shift;

  my $in = read_lines($file);
  my %m = ( w => length($in->[0]), h => ~~@$in, e => {}, s => {} );
  for my $y (0..$m{h}-1) {
    my $l = [split //, $in->[$y]];
    for my $x (0..$m{w}-1) {
      my $ch = $l->[$x];
      $m{e}->{$x,$y} = '>' if ($ch eq '>');
      $m{s}->{$x,$y} = 'v' if ($ch eq 'v');
    }
  }
  return \%m;
}

sub pp {
  my ($in) = @_;
  for my $y (0..$in->{h}-1) {
    for my $x (0..$in->{w}-1) {
      print $in->{e}->{$x,$y} // $in->{s}->{$x,$y} // '.';
    }
    print "\n";
  }
}

sub iter {
  my ($in) = @_;
  my %n;
  my @m;
  for my $xy (keys %{$in->{e}}) {
    my ($x, $y) = split/,/,$xy;
    my ($xm, $ym) = (($x+1)%$in->{w}, $y);
    push @m, [$x,$y, $xm, $ym] if (!exists $in->{e}->{$xm,$ym} &&
                                   !exists $in->{s}->{$xm,$ym});
  }
  my $moved = scalar @m;
  for my $m (@m) {
    $in->{e}->{$m->[2],$m->[3]} = delete $in->{e}->{$m->[0],$m->[1]};
  }
  @m =();
  for my $xy (keys %{$in->{s}}) {
    my ($x, $y) = split/,/,$xy;
    my ($xm, $ym) = ($x, ($y+1)%$in->{h});
    push @m, [$x,$y, $xm, $ym] if (!exists $in->{e}->{$xm,$ym} &&
                                   !exists $in->{s}->{$xm,$ym});
  }
  $moved += scalar @m;
  for my $m (@m) {
    $in->{s}->{$m->[2],$m->[3]} = delete $in->{s}->{$m->[0],$m->[1]};
  }
  return $moved;
}

sub calc {
  my ($in, $days) = @_;
  $days //= 99999999;
  for my $d (1..$days) {
    unless (iter($in)) {
      return $d;
    }
  }
  return -1;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 58 ],
     [ "input.txt", 417 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}
