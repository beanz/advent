#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);
#print dd([$i]); exit;
my $i2 = read_lines($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

sub run {
  my ($i, $part) = @_;
  my %seen;
  my $ip = 0;
  my $acc = 0;
  while (!exists $seen{$ip} && $ip < @$i) {
    $seen{$ip}++;
    my ($op, $arg) = split / /,$i->[$ip];
    printf "%d %d %s %d\n", $ip, $acc, $op, $arg if DEBUG;
    $ip++;
    if ($op eq "acc") {
      $acc += $arg;
    } elsif ($op eq "jmp") {
      $ip += $arg - 1;
    }
  }
  return [$acc, $ip];
}

sub calc {
  my ($i, $part) = @_;
  return run($i)->[0];
}

sub calc2 {
  my ($i, $part) = @_;
  for my $mi (0..@$i-1) {
    my $mod = [@$i];
    next unless ($mod->[$mi] =~ s/^jmp/nop/ || $mod->[$mi] =~ s/^nop/jmp/);
    my $res = run($mod);
    return $res->[0] if ($res->[1] >= @$mod);
  }
  return 0;
}

testPart1() if (TEST);

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 5 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 8 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
