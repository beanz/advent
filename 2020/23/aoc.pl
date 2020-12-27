#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$; = $" = ', ';

my $file = shift // "input.txt";
my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

{
  package Cup;
  use constant { VALUE => 0, CW => 1, CCW => 2 };
  sub new {
    my ($pkg, $val) = @_;
    my $self = bless [$val, undef, undef], $pkg;
    $self->[CW] = $self->[CCW] = $self;
  }
  sub pp {
    my ($self) = @_;
    my @s = ($self->[VALUE]);
    my $cup = $self->[CW];
    while ($cup->[VALUE] != $self->[VALUE]) {
      push @s, $cup->[VALUE];
      $cup = $cup->[CW];
    }
    join ' ', @s;
  }
  sub val {
    $_[0]->[VALUE];
  }
  sub cw {
    $_[0]->[CW];
  }
  sub ccw {
    $_[0]->[CCW];
  }
  sub insert {
    my ($self, $new) = @_;
    my $last = $new->[CCW];
    my $next = $self->[CW];
    $self->[CW] = $new;
    $last->[CW] = $next;
    $new->[CCW] = $self;
  }
  sub pick {
    my ($self) = @_;
    my $p1 = $self->[CW];
    my $p2 = $p1->[CW];
    my $p3 = $p2->[CW];
    my $n = $p3->[CW];

    # fix ring
    $self->[CW] = $n;
    $n->[CCW] = $self;

    # fix picked
    $p1->[CCW] = $p3;
    $p3->[CW] = $p1;
    $p1;
  }
  sub part1 {
    my ($self) = @_;
    my $s = "";
    my $cup = $self->[CW];
    while ($cup->[VALUE] != $self->[VALUE]) {
      $s .= $cup->[VALUE];
      $cup = $cup->[CW];
    }
    $s;
  }
}

sub run {
  my ($in, $moves, $max) = @_;
  my @init = split //, $in->[0];
  my @cup = ();
  my $cur;
  my $last;
  for my $v (@init) {
    my $n = Cup->new($v);
    $cup[$v] = $n;
    unless (defined $cur) {
      $cur = $n;
    }
    if (defined $last) {
      $last->insert($n);
    }
    $last = $n;
  }
  for my $v (10..$max) {
    my $n = Cup->new($v);
    $cup[$v] = $n;
    $last->insert($n);
    $last = $n;
  }
  for my $move (1..$moves) {
    my $pick = $cur->pick();
    my $dst = $cur->[Cup::VALUE];
    do {
      $dst--;
      $dst = $max if ($dst == 0);
    } while ($pick->[Cup::VALUE] == $dst ||
             $pick->[Cup::CW]->[Cup::VALUE] == $dst ||
             $pick->[Cup::CCW]->[Cup::VALUE] == $dst);
    my $dcup = $cup[$dst];
    $dcup->insert($pick);
    $cur = $cur->[Cup::CW];
  }
  return $cup[1];
}

sub calc {
  my ($in, $moves) = @_;
  $moves //= 100;
  my $cup1 = run($in, $moves, 9);
  return $cup1->part1();
}

sub calc2 {
  my ($in, $moves, $max) = @_;
  $moves //= 10000000;
  $max //= 1000000;
  my $cup1 = run($in, $moves, $max);
  return $cup1->cw->val * $cup1->cw->cw->val;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 0, 25467389 ],
     [ "test1.txt", 1, 54673289 ],
     [ "test1.txt", 10, 92658374 ],
     [ "test1.txt", 100, 67384529 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 1 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 30, 20, 136 ],
     [ "test1.txt", 100, 20, 54 ],
     [ "test1.txt", 1000, 20, 42 ],
     [ "test1.txt", 10000, 20, 285 ],
     [ "test1.txt", 10001, 20, 285 ],
     [ "test1.txt", 10, 1000000, 12 ],
     [ "test1.txt", 100, 1000000, 12 ],
     [ "test1.txt", 1000000, 1000000, 126 ],
     [ "test1.txt", 2000000, 1000000, 32999175 ],
     [ "test1.txt", 10000000, 1000000, 149245887792 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]), $tc->[1], $tc->[2]);
    assertEq("Test 2 [$tc->[0] $tc->[1] x $tc->[2]]", $res, $tc->[3]);
  }
}
