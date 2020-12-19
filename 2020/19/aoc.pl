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
my $i = read_chunks($file);
my $i2 = read_chunks($file);

sub make_re {
  my ($rs, $n) = @_;
  #print "make_re: $n\n";
  my $r = $rs->{$n};
  if (ref $r) {
    return
      '(?:'.(join'|',
       map {
          (join '',map { make_re($rs, $_) } @$_ )
       } @$r).')';
  } else {
    #print "ch $r\n";
    return $r;
  }
}

sub parse_rules {
  my ($in) = @_;
  my %r;
  my @v;
  my $re;
  for my $l (@$in) {
    if ($l =~ s/^(\d+): //) {
      my $n = $1;
      if ($l =~ /"(.)"/) {
        $r{$n} = $1;
      } else {
        $r{$n} = [map { [split / /, $_] } split / \| /, $l];
      }
    }
  }
  return \%r;
}

sub calc {
  my ($in) = @_;
  my $t = 0;
  my $r = parse_rules([split/\n/,$in->[0]]);
  my $re = '^'.make_re($r, 0).'$';
  #print "made $re\n";
  my @v = split/\n/,$in->[1];
  #dd([$r, \@v],[qw/r v/]);
  for my $v (@v) {
    #print "checking $v\n";
    $t++ if ($v =~ $re);
  }
  return $t;
}

sub calc2 {
  my ($in) = @_;
  my $t = 0;
  my $r = parse_rules([split/\n/,$in->[0]]);
  my $re42 = make_re($r, 42);
  my $re31 = make_re($r, 31);
  #print "re42 = $re42\n";
  #print "re31 = $re31\n";
  $r->{8} = make_re($r, 42).'+';
  $r->{11} = '(?:'.(join'|', map "$re42\{$_}$re31\{$_}", (1..5)).')';
  my $re = '^'.make_re($r, 0).'$';
  #print "made $re\n";
  my @v = split/\n/,$in->[1];
  #dd([$r, \@v],[qw/r v/]);
  for my $v (@v) {
    #print "checking $v\n";
    if ($v =~ /$re/) {
      $t++
    }
  }
  return $t;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test0.txt", 1 ],
     [ "test1.txt", 1 ],
     [ "test2.txt", 2 ],
     [ "input.txt", 285 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_chunks($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "input.txt", 412 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_chunks($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
