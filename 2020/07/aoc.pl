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

sub cc {
  my ($cc, $k, $a) = @_;
  for my $sk (@{$cc->{$k}||[]}) {
    $a->{$sk}++;
    cc($cc, $sk, $a) if (exists $cc->{$k});
  }
  return;
}

sub calc {
  my ($i, $part) = @_;
  my $s = 0;
  my %c = ();
  for my $l (@$i) {
    next unless ($l =~ /^(.*) bags contain (.*)$/);
    my $top = $1;
    my $rest = $2;
    next if ($rest =~ /no other bags/);
    while ($rest =~ s/(\d+) (\w+ \w+) bag//) {
      push @{$c{$2}}, $top;
    }
  }
  my %u;
  cc(\%c, 'shiny gold', \%u);
  return scalar keys %u;
}

sub cc2 {
  my ($r, $k) = @_;
  my $c = 1;
  for my $rec (@{$r->{$k}||[]}) {
    my ($n, $sk) = @$rec;
    $c += $n * cc2($r, $sk);
  }
  return $c;
}

sub calc2 {
  my ($i, $part) = @_;
  my $s = 0;
  my %r = ();
  for my $l (@$i) {
    next unless ($l =~ /^(.*) bags contain (.*)$/);
    my $top = $1;
    my $rest = $2;
    next if ($rest =~ /no other bags/);
    while ($rest =~ s/(\d+) (\w+ \w+) bag//) {
      push @{$r{$top}}, [$1, $2];
    }
  }
  return cc2(\%r, 'shiny gold')-1;
}

testPart1() if (TEST);

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 4 ],
     [ "test2.txt", 0 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 32 ],
     [ "test2.txt", 126 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
