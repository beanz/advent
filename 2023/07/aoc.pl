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

my $reader = \&read_guess;
my $i = $reader->($file);
my $i2 = $reader->($file);

my @sc = (qw/0 1 2 3 4 5 6 7 8 9 T J Q K A/);
my %msc;
for my $i (0 .. @sc - 1) {
  $msc{$sc[$i]} = $i;
}

my @sc2 = (qw/J 1 2 3 4 5 6 7 8 9 T 0 Q K A/);
my %msc2;
for my $i (0 .. @sc2 - 1) {
  $msc2{$sc2[$i]} = $i;
}

sub score {
  my ($h) = @_;
  my %c;
  for (split //, $h) {
    $c{$_}++;
  }
  my @cc = sort {$b <=> $a} values %c;
  if (@cc == 1) {
    return 0;
  }
  if ($cc[0] == 4) {
    return 1;
  }
  if ($cc[0] == 3) {
    if (@cc == 2) {
      return 2;
    }
    return 3;
  }
  if ($cc[0] == 2) {
    if ($cc[1] == 2) {
      return 4;
    }
    return 5;
  }
  return 9;
}

sub comp {
  my ($a, $b) = @_;
  my ($sa) = score($a);
  my ($sb) = score($b);
  if ($sa == $sb) {
    my @ca = split //, $a;
    my @cb = split //, $b;
    for my $i (0 .. 4) {
      if ($ca[$i] eq $cb[$i]) {
        next;
      }
      return $msc{$ca[$i]} <=> $msc{$cb[$i]};
    }
    die "equal?";
  }
  return $sb <=> $sa;
}

sub score2 {
  my ($h) = @_;
  my $b = score($h);
  if ($h !~ /J/) {
    return $b;
  }
  for (qw/1 2 3 4 5 6 7 8 9 T Q K A/) {
    my $hh = $h;
    $hh =~ s/J/$_/g;
    my $n = score($hh);
    $b = $n if ($b > $n);
  }
  return $b;
}

sub comp2 {
  my ($a, $b) = @_;
  my ($sa) = score2($a);
  my ($sb) = score2($b);

  if ($sa == $sb) {
    my @ca = split //, $a;
    my @cb = split //, $b;
    for my $i (0 .. 4) {
      if ($ca[$i] eq $cb[$i]) {
        next;
      }
      return $msc2{$ca[$i]} <=> $msc2{$cb[$i]};
    }
    die "equal?";
  }
  return $sb <=> $sa;
}

#print score("AAAAA"), "\n";
#print score("AA8AA"), "\n";
#print score("23332"), "\n";
#print score("TTT98"), "\n";
#print score("23432"), "\n";
#print score("A23A4"), "\n";
#print score("23456"), "\n";

#print score("33332"), "\n";
#print score("2AAAA"), "\n";
#print " $_\n" for (sort { comp($a, $b) } qw/33332 2AAAA/);

#print score("77888"), "\n";
#print score("77788"), "\n";
#print " $_\n" for (sort { comp($a, $b) } qw/77888 77788/);

#print " $_\n" for (sort {comp($a, $b)} qw/32T3K T55J5 KK677 KTJJT QQQJA/);

sub calc {
  my ($in) = @_;
  my $c = 0;
  my @s = sort {comp($a->[0], $b->[0])} @$in;
  for my $i (0 .. @s - 1) {
    my ($h, $b) = @{$s[$i]};
    print "$h $b ", $i + 1, " ", score($h), "\n" if DEBUG;
    $c += $b * ($i + 1);
  }
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  my @s = sort {comp2($a->[0], $b->[0])} @$in;
  for my $i (0 .. @s - 1) {
    my ($h, $b) = @{$s[$i]};
    print "$h $b ", $i + 1, " ", score2($h), "\n" if DEBUG;
    $c += $b * ($i + 1);
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 6440], ["input.txt", 256448566],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test1.txt", 5905], ["input.txt", 254412181],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}
