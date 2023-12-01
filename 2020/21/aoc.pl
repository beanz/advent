#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_ing;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_ing {
  my ($file) = @_;
  my $in = read_lines($file);
  my %a;
  my %i;
  for my $i (0..@$in-1) {
    my $l = $in->[$i];
    die "invalid: $l\n" unless ($l =~ /^(.*) \(contains (.*)\)$/);
    my ($is, $as) = ($1, $2);
    for my $ing (split / /, $is) {
      $i{$ing}->{$i}++;
    }
    for my $al (split /, /, $as) {
      $a{$al}->{$i}++;
    }
  }
  return [\%a, \%i];
}

sub propsubset {
  my ($a, $b) = @_;
  for my $k (%$b) {
    return undef unless (exists $a->{$k});
  }
  return 1;
}

sub calc {
  my ($in) = @_;
  my ($a, $i) = @$in;
  my %n;
  my %pa;
  my $t = 0;
  for my $ing (sort keys %{$i}) {
    my $possAl = 0;
    for my $al (keys %{$a}) {
      my $maybe = 1;
      for my $line (keys %{$a->{$al}}) {
        $maybe = 0 unless ($i->{$ing}->{$line});
      }
      if ($maybe) {
        #print "$ing could be $al\n";
        $pa{$ing}->{$al}++;
        $possAl = 1;
      }
    }
    if (!$possAl) {
      $n{$ing}++;
      $t += keys %{$i->{$ing}};
    }
  }
  #print "non allergens: @{[keys %n]}\n";
  push @$in, \%pa;
  return $t;
}

sub calc2 {
  my ($in) = @_;
  calc($in);
  my ($as, $i, $pa) = @$in;
  my %res;
  while (keys %$pa) {
    for my $ing (keys %$pa) {
      if (keys %{$pa->{$ing}} == 1) {
        my $al = (keys %{$pa->{$ing}})[0];
        $res{$ing} = $al;
        delete $pa->{$ing};
        for my $ing (keys %$pa) {
          delete $pa->{$ing}->{$al};
        }
      }
    }
  }
  #dd([\%res]);
  return join ',', sort { $res{$a} cmp $res{$b} } keys %res;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 5 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", "mxmxvkd,sqjhc,fvjkl" ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
