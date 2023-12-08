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

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m = (L => {}, R => {}, S => [], I => 0, P => []);
  $m{S} = [split //, $in->[0]];
  for my $i (2 .. (@$in - 1)) {
    $in->[$i] =~ s/[()=]\s*//g;
    $in->[$i] =~ s/,//g;
    my ($f, $l, $r) = split /\s+/, $in->[$i];
    print "$i: $f $l $r\n" if DEBUG;
    $m{L}->{$f} = $l;
    $m{R}->{$f} = $r;
    push @{$m{P}}, $f if ($f =~ /A$/);
  }
  return \%m;
}

sub calc {
  my ($in, $start, $end) = @_;
  $start //= 'AAA';
  $end //= qr/^ZZZ$/;
  my $c = 0;
  my $p = $start;
  while (1) {
    my $s = $in->{S}->[($c % (@{$in->{S}}))];
    my $n = $in->{$s}->{$p};
    print "$p $s $n\n" if (DEBUG > 1);
    $p = $n;
    $c++;
    return 0 unless (defined $p);
    last if ($p =~ $end);
  }
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my $gc = @{$in->{P}};
  my @c;
  for my $i (0 .. ($gc - 1)) {
    my $c = calc($in, $in->{P}->[$i], qr/Z$/);
    print "Found cycle for $i ", $c, "\n" if DEBUG;
    push @c, $c;
  }
  my $lcm = 1;
  for (@c) {
    $lcm = lcm($lcm, $_);
  }
  return $lcm;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 2], ["test2.txt", 6], ["input.txt", 20569],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test3.txt", 6], ["input.txt", 21366921060721],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
