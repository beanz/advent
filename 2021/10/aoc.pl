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
my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub calc {
  my ($in) = @_;
  my $p1 = 0;
  my @p2;
  my %s1 = ( ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 );
  my %s2 = ( '(' => 1, '[' => 2, '{' => 3, '<' => 4 );
  my %r = ( '(' => ')', '[' => ']', '{' => '}', '<' => '>' );
 LINE:
  for my $l (@$in) {
    my @e;
    while ($l =~ s/\(\)//g || $l =~ s/\[\]//g || $l =~ s/{}//g || $l =~ s/<>//g) {}
    for my $ch (split//, $l) {
      if (exists $r{$ch}) {
        push @e, $r{$ch};
      } else {
        my $x = pop @e;
        if ($ch ne $x) {
          $p1 += $s1{$ch};
          next LINE;
        }
      }
    }
    my $c= 0;
    for my $ch (reverse split //, $l) {
      $c = $c*5 + $s2{$ch};
    }
    push @p2, $c;
  }
  return [$p1, [sort { $a <=> $b } @p2]->[@p2/2]];
}

testCalc() if (TEST);

my ($p1, $p2) = @{calc($i)};
print "Part 1: ", $p1, "\n";
print "Part 2: ", $p2, "\n";

sub testCalc {
  my @test_cases =
    (
     [ "test1.txt", 26397, 288957 ],
     [ "input.txt", 390993, 2391385187 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
