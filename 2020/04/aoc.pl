#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_chunky_records($file);

sub pf {
  return [qw/byr iyr eyr hgt hcl ecl pid/];
}

sub pfs {
  return
    [
     [byr => sub { $_[0] =~ /^\d{4}$/ && $_[0] >= 1920 && $_[0] <= 2002 }],
     [iyr => sub { $_[0] =~ /^\d{4}$/ && $_[0] >= 2010 && $_[0] <= 2020 }],
     [eyr => sub { $_[0] =~ /^\d{4}$/ && $_[0] >= 2020 && $_[0] <= 2030 }],
     [hgt => sub {
       $_[0] =~ /^(\d+)(cm|in)$/ &&
         ( ($2 eq 'cm' && $1 >= 150 && $1 <= 193) ||
           ($2 eq 'in' && $1 >= 59 && $1 <= 76) )
       }],
     [hcl => sub { $_[0] =~ /^#[0-9a-f]{6}$/ }],
     [ecl => sub { $_[0] =~ /^(?:amb|blu|brn|gry|grn|hzl|oth)$/ }],
     [pid => sub { $_[0] =~ /^\d{9}$/ }],
    ];
}

sub calc {
  my ($i, $part) = @_;
  $part //= 1;
  my $c = 0;
 PP:
  for my $p (@$i) {
    for my $fp (@{pf()}) {
      unless (exists $p->{$fp}) {
        next PP;
      }
    }
    $c++;
  }
  return $c;
}

if (TEST) {
  my @test_cases =
    (
     [ "test1.txt", 2 ],
     [ "test2.txt", 4 ],
     [ "test3.txt", 4 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_chunky_records($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}
#print dd($i); exit;
my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i, $part) = @_;
  $part //= 1;
  my $c = 0;
 PP:
  for my $p (@$i) {
    for my $fpr (@{pfs()}) {
      my $fp = $fpr->[0];
      my $fn = $fpr->[1];
      unless (exists $p->{$fp} && $fn->($p->{$fp})) {
        print STDERR "Invalid $fp: ", ($p->{$fp} // ""), "\n" if DEBUG;
        next PP;
      }
    }
    $c++;
  }
  return $c;
}

if (TEST) {
  my @test_cases =
    (
     [ "test1.txt", 2 ],
     [ "test2.txt", 0 ],
     [ "test3.txt", 4 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_chunky_records($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}

$i = read_chunky_records($file);
print "Part 2: ", calc2($i), "\n";
