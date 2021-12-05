#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

use constant
  {
   BLACK => 0,
   WHITE => 1,
   TRANS => 2,
  };

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i, 25, 6);

sub parse_input {
  my ($lines, $w, $h) = @_;
  my @l =
    map { [ map { [unpack '(A)*', $_] } unpack '(A'.$w.')*', $_ ]
        } unpack '(A'.($w*$h).')*', $lines->[0];
  return \@l;
}

sub calc {
  my ($p, $part) = @_;
  my $min;
  my $ml;
  for my $i (0..@$p-1) {
    my $d0 = sum(scalar map { grep /0/, @$_ } @{$p->[$i]});
    if (!defined $min || $min > $d0) {
      $min = $d0;
      $ml = $i;
    }
  }
  my $d1 = sum(scalar map { grep /1/, @$_ } @{$p->[$ml]});
  my $d2 = sum(scalar map { grep /2/, @$_ } @{$p->[$ml]});
  return $d1 * $d2;
}

sub pp {
  return join "\n\n", map { join "\n", map { join "", @$_ } @$_ } @{$_[0]};
}

if (TEST) {
  my @test_cases =
    (
     [ ["123456789012"], [[["1","2","3"],["4","5","6"]],
                          [["7","8","9"],["0","1","2"]]]],
    );
  for my $tc (@test_cases) {
    my $res = parse_input($tc->[0], 3, 2);
    assertEq("Test 1 [@{$tc->[0]}]", pp($res), pp($tc->[1]));
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub pixel {
  my ($p, $x, $y) = @_;
  for my $l (@$p) {
    my $c = $l->[$y]->[$x];
    if ($c != TRANS) {
      return $c;
    }
  }
  return "U";
}

sub calc2 {
  my ($p) = @_;
  my $im;
  for my $y (0..@{$p->[0]}-1) {
    for my $x (0..@{$p->[0]->[0]}-1) {
      $im .= pixel($p, $x, $y) == BLACK ? ' ' : '#';
    }
    $im .= "\n";
  }
  return $im;
}

if (TEST) {
  assertEq("Test 2", calc2(parse_input(["0222112222120000"], 2, 2), 2, 2),
           " #\n# \n");
}

print "Part 2:\n", calc2($i, 25, 6), "\n";
