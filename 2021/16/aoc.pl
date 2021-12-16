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
#my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);


sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  return join "", map { sprintf "%08b", $_ } unpack "C*", pack "H*", $in->[0];
}

sub num {
  oct "0b".substr $_[0], 0, $_[1], ''
}

sub packet {
  my $version = num($_[0], 3);
  my $type = num($_[0], 3);
  if ($type == 4) {
    my $n = 0;
    while (1) {
      my $a = num($_[0], 5);
      $n = ($n << 4) + ($a & 0xf);
      last unless ($a & 0x10);
    }
    print "V=$version T=$type N=$n\n" if DEBUG;
    return [$version, $n];
  } else {
    my $i = num($_[0], 1);
    if ($i == 0) {
      # 15-bit
      my $l = num($_[0], 15);
      print "V=$version T=$type I=$i L=$l\n" if DEBUG;
      my $sub = substr $_[0], 0, $l, '';
      my $vs = $version;
      my @p;
      while ($sub) {
        my $p = packet($sub);
        my ($v, $n) = @$p;
        $vs += $v;
        push @p, $n;
      }
      return [$vs, value($type, \@p)];
    } else {
      # 11-bit
      my $l = num($_[0], 11);
      print "V=$version T=$type I=$i L=$l\n" if DEBUG;
      my $vs = $version;
      my @p;
      for (1..$l) {
        my $p = packet($_[0]);
        my ($v, $n) = @$p;
        $vs += $v;
        push @p, $n;
      }
      return [$vs, value($type, \@p)];
    }
  }
  return $version;
}

my @fun =
  (
   \&sum,
   \&product,
   \&min,
   \&max,
   sub { die "Not op: @_\n" },
   sub { $_[0] > $_[1] ? 1 : 0 }, # greater than
   sub { $_[0] < $_[1] ? 1 : 0 }, # less than
   sub { $_[0] == $_[1] ? 1 : 0 }, # equal to
  );

sub value {
  my ($type, $args) = @_;
  return $fun[$type]->(@$args)
}

sub calc {
  my ($in) = @_;
  dd([$in],[qw/in/]);
  my ($v, $n) = @{packet($in)};
  return [$v,$n];
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  return $c;
}

testPacket() if (TEST);

my ($p1, $p2) = @{packet($i)};
print "Part 1: ", $p1, "\n";
print "Part 2: ", $p2, "\n";

sub testPacket {
  my @test_cases =
    (
     [ "test1a.txt", 6, 2021 ],
     [ "test1b.txt", 9, 1 ],
     [ "test1c.txt", 14, 3 ],
     [ "test1d.txt", 16, 15 ],
     [ "test1e.txt", 12, 46 ],
     [ "test1f.txt", 23, 46 ],
     [ "test1g.txt", 31, 54 ],
     [ "test2a.txt", 14, 3 ],
     [ "test2b.txt", 8, 54 ],
     [ "test2c.txt", 15, 7 ],
     [ "test2d.txt", 11, 9 ],
     [ "test2e.txt", 13, 1 ],
     [ "test2f.txt", 19, 0 ],
     [ "test2g.txt", 16, 0 ],
     [ "test2h.txt", 20, 1 ],
    );
  for my $tc (@test_cases) {
    my ($p1, $p2) = @{packet($reader->($tc->[0]))};
    assertEq("Test 1 [$tc->[0]]", $p1, $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $p2, $tc->[2]);
  }
}
