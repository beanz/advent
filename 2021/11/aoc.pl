#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = sub {
  read_dense_map($_[0], undef, sub { $_[0]<=9 ? $_[0] == -1 ? 'F' : $_[0] : 'X' });
};
my $i = $reader->($file);
my $i2 = $reader->($file);

sub flash {
  my ($in, $p) = @_;
  $in->set_idx($p, -1);
  for my $nb ($in->neighbours8($p)) {
    my $v = $in->get_idx($nb);
    next if ($v == -1); # already flashed
    $in->set_idx($nb, $v+1);
    if ($v >= 9) {
      flash($in, $nb);
    }
  }
}

sub calc {
  my ($in, $p1_days) = @_;
  my $c = 0;
  my $day = 1;
  my $p1 = -1;
  while (1) {
    for my $i (0..$in->last_index) {
      $in->add_idx($i, 1);
    }
    $in->visit(sub {
                 my ($in, $p, $v) = @_;
                 if ($v > 9) {
                   flash($in, $p);
                 }
               });
    my $p2 = 0;
    for my $i (0..$in->last_index) {
      if ($in->get_idx($i) == -1) {
        $in->set_idx($i, 0);
        $c++;
        $p2++;
      }
    }
    print "Day $day ($p2)\n", $in->pretty(), "\n" if DEBUG;
    if ($day == $p1_days) {
      $p1 = $c;
    }
    if ($p2 == $in->len) {
      return [$p1, $day];
    }
    $day++;
  }
}

testParts() if (TEST);

my $r = calc($i, 100);
print "Part 1: ", $r->[0], "\n";
print "Part 2: ", $r->[1], "\n";

sub testParts {
  my @test_cases =
    (
     [ "test0.txt", 1, 9, 6 ],
     [ "test1.txt", 100, 1656, 195 ],
     [ "input.txt", 100, 1652, 220 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 1 [$tc->[0] x $tc->[1]]", $res->[0], $tc->[2]);
    assertEq("Test 2 [$tc->[0] x $tc->[1]]", $res->[1], $tc->[3]);
  }
}
