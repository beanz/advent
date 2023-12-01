#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Math::BigInt lib => 'GMP';
use List::MoreUtils qw/first_index/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

sub shuffle {
  my ($lines, $n) = @_;
  my @d = (0..$n-1);
  for my $shuffle (@$lines) {
    if ($shuffle eq "deal into new stack") {
      @d = reverse @d;
    } elsif ($shuffle =~ /^cut (\d+)/) {
      @d = ((splice @d, $1, $#d), @d);
    } elsif ($shuffle =~ /^cut (-\d+)/) {
      @d = ((splice @d, @d+$1, -$1), @d);
    } elsif ($shuffle =~ /deal with increment (\d+)/) {
      my @o = @d;
      for my $i (0..$#d) {
        $d[($i*$1)%@o] = $o[$i];
      }
    }
  }
  return \@d;
}

sub part1 {
  my ($lines, $n, $pos) = @_;
  return first_index { $_ == $pos } @{shuffle($lines, $n)};
}

if (TEST) {
  my @test_cases =
    (
     [ read_lines("test1a.txt"), 10, [reverse 0..9] ],
     [ read_lines("test1b.txt"), 10, [3..9, 0..2] ],
     [ read_lines("test1c.txt"), 10, [6..9, 0..5] ],
     [ read_lines("test1d.txt"), 10, [qw/0 7 4 1 8 5 2 9 6 3/] ],
     [ [read_lines("test1e.txt")->[0]], 10, [qw/0 3 6 9 2 5 8 1 4 7/] ],
     [ read_lines("test1e.txt"), 10, [qw/0 3 6 9 2 5 8 1 4 7/] ],
     [ read_lines("test1f.txt"), 10, [qw/3 0 7 4 1 8 5 2 9 6/] ],
     [ read_lines("test1g.txt"), 10, [qw/6 3 0 7 4 1 8 5 2 9/] ],
     [ read_lines("test1h.txt"), 10, [qw/9 2 5 8 1 4 7 0 3 6/] ],
    );
  for my $tc (@test_cases) {
    my $res = shuffle($tc->[0], $tc->[1]);
    assertEq("Test 1 [@{$tc->[0]}] x $tc->[1]",
             (join ',',@$res), (join ',',@{$tc->[2]}));
  }
}
my $part1 = part1(\@i, 10007, 2019);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($lines, $n, $pos, $times) = @_;
  $times //= 1;
  $times = Math::BigInt->new($times);
  $n = Math::BigInt->new($n);
  $pos = Math::BigInt->new($pos);
  my $a = Math::BigInt->bone();
  my $b = Math::BigInt->bzero();
  for my $shuffle (reverse @$lines) {
    if ($shuffle eq "deal into new stack") {
      $b->bmul(-1)->bdec();
      $a->bmul(-1);
    } elsif ($shuffle =~ /^cut (-?\d+)/) {
      $b->badd($1);
    } elsif ($shuffle =~ /deal with increment (\d+)/) {
      my $m = Math::BigInt->new($1)->bmodinv($n);
      $a->bmul($m);
      $b->bmul($m);
    }
    $a->bmod($n);
    $b->bmod($n);
    print "shuffle: $shuffle yields $a & $b\n" if DEBUG;
  }
  # new = a*old + b
  my $exp = $a->copy->bmodpow($times, $n);
  my $invmod = $a->copy->bdec->bmodinv($n);
  return
    $exp->copy->bmul(
        $pos)->badd(
            $b->copy()->bmul(
                $exp->copy()->bdec()->bmul($invmod->copy())))->bmod($n);
}


if (TEST) {
  my $validate = calc2(\@i, 10007, $part1, 1);
  assertEq("Reverse Part 1: ", $validate, 2019);
}

my $pos = 2020;
print "Part 2: ", calc2(\@i, 119315717514047, $pos, 101741582076661), "\n";
