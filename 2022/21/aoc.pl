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
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my @l = split /:? +/, $l;
    my $k = shift @l;
    $m{$k} = \@l;

    #print "$i: $k => @l\n";
  }
  return \%m;
}

sub solve {
  my ($m, $k, $num) = @_;
  if (defined $num && $k eq "humn") {
    return $num;
  }
  my @l = @{$m->{$k}};
  if (@l == 1) {
    return $l[0];
  }
  if ($l[1] eq "+") {
    return solve($m, $l[0], $num) + solve($m, $l[2], $num);
  }
  if ($l[1] eq "*") {
    return solve($m, $l[0], $num) * solve($m, $l[2], $num);
  }
  if ($l[1] eq "/") {
    return solve($m, $l[0], $num) / solve($m, $l[2], $num);
  }
  if ($l[1] eq "-") {
    return solve($m, $l[0], $num) - solve($m, $l[2], $num);
  }
  die "broken?";
}

sub calc {
  my ($in) = @_;
  return solve($in, "root");
}

sub solve2 {
  my ($m, $k) = @_;
  if ($k eq "humn") {
    return '$x';
  }
  my @l = @{$m->{$k}};
  if (@l == 1) {
    return $l[0];
  }
  my $sol = '(' . solve2($m, $l[0]) . $l[1] . solve2($m, $l[2]) . ')';
  if ($sol !~ /\$x/) {
    return eval $sol;
  }
  return $sol;
}

sub calc2 {
  my ($m) = @_;
  my $c = 0;
  my $expa = solve2($m, $m->{root}->[0]);
  my $expb = solve2($m, $m->{root}->[2]);
  print "$expa == $expb\n" if DEBUG;
  my $reduced;
  do {
    $reduced = 0;
    if ($expa =~ m!^\((.*)/(\d+)\)$!) {
      $expb = $expb * $2;
      $expa = $1;
      $reduced = 1;
    }
    if ($expa =~ m!^\((\d+)\+(.*)\)$!) {
      $expb = $expb - $1;
      $expa = $2;
      $reduced = 1;
    }
    if ($expa =~ m!^\((.*)\+(\d+)\)$!) {
      $expb = $expb - $2;
      $expa = $1;
      $reduced = 1;
    }
    if ($expa =~ m!^\((\d+)\*(.*)\)$!) {
      $expb = $expb / $1;
      $expa = $2;
      $reduced = 1;
    }
    if ($expa =~ m!^\((.*)\*(\d+)\)$!) {
      $expb = $expb / $2;
      $expa = $1;
      $reduced = 1;
    }
    if ($expa =~ m!^\((\d+)-(.*)\)$!) {
      $expb = $1-$expb;
      $expa = $2;
      $reduced = 1;
    }
    if ($expa =~ m!^\((.*)-(\d+)\)$!) {
      $expb = $expb + $2;
      $expa = $1;
      $reduced = 1;
    }
  } while ($reduced);
  die unless ($expa eq '$x');
  return $expb;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 152], ["input.txt", 41857219607906],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test1.txt", 301], ["input.txt", 3916936880448],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
