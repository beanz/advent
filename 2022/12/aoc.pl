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
my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my %in = (m => read_dense_map($file), st => []);
  $in{m}->visit(
    sub {
      my ($m, $i, $ch) = @_;
      if ($ch eq 'S') {
        $in{s} = [$i, 0, 'a'];
        push @{$in{st}}, [$i, 0, 'a'];
      } elsif ($ch eq 'E') {
        $m->set_idx($i, 'z');
        $in{e} = $i;
      } elsif ($ch eq 'a') {
        push @{$in{st}}, [$i, 0, 'a'];
      }
    }
  );
  return \%in;
}

sub calc {
  my ($in, $p2) = @_;
  my @todo = $p2 ? @{$in->{st}} : ($in->{s});
  my %v;
  while (@todo) {
    my ($i, $s, $ch) = @{shift @todo};
    if (exists $v{$i}) {
      next;
    }
    $v{$i}++;
    if ($in->{e} == $i) {
      return $s;
    }
    for my $nb ($in->{m}->neighbours4($i)) {
      my $nch = $in->{m}->get_idx($nb);
      unless (ord($nch) <= ord($ch) + 1) {
        next;
      }
      push @todo, [$nb, $s + 1, $nch];
    }
  }
  return -1;
}

sub calc2 {
  return calc(@_, 1);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 31], ["input.txt", 481],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test1.txt", 29], ["input.txt", 480],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
