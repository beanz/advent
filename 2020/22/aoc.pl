#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_decks;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_decks {
  my ($file) = @_;
  my $in = read_chunks($file);
  #dd([$in]);
  my @p1 = ($in->[0] =~ m/^(\d+)/mg );
  my @p2 = ($in->[1] =~ m/^(\d+)/mg);
  #dd([\@p1, \@p2],[qw/p1 p2/]);
  return [\@p1, \@p2];
}

sub score {
  my ($w) = @_;
  my $t = 0;
  my $l = @{$w};
  for my $i (1..$l) {
    $t += (1 + $l - $i) * $w->[$i-1];
  }
  return $t;
}

sub rc {
  my ($p1, $p2, $part2) = @_;
  my %seen;
  my $r = 1;
  while (@$p1 && @$p2) {
    my $k = score($p1) * (31 + score($p2));
    #$k = join '!', map { join ',', @$_ } $p1, $p2;
    print "$r: $k\n" if DEBUG;
    return $p1 if ($seen{$k});
    $seen{$k}++;
    my $c1 = shift @$p1;
    my $c2 = shift @$p2;
    print "P $c1 $c2\n" if DEBUG;
    my $w;
    if ($part2 && @$p1 >= $c1 && @$p2 >= $c2) {
      my @np1 = map $p1->[$_], (0..$c1-1);
      my @np2 = map $p2->[$_], (0..$c2-1);
      print "sg!\n" if DEBUG;
      my $sw = rc(\@np1, \@np2, 1);
      $w = $sw eq \@np1 ? $p1 : $p2;
    } else {
      $w = $c1 > $c2 ? $p1 : $p2;
    }
    push @$w, @{$w eq $p1 ? [$c1, $c2] : [$c2, $c1]};
    $r++;
  }
  my $w = @$p1 ? $p1 : $p2;
  print($w eq $p1 ? "p1!!\n" : "p2!!\n") if DEBUG;
  return $w;
}

sub calc {
  my ($in) = @_;
  my $w = rc($in->[0], $in->[1], 0);
  return score($w);
}

sub calc2 {
  my ($in) = @_;
  my $w = rc($in->[0], $in->[1], 1);
  return score($w);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 306 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 291 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
