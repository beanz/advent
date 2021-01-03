#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub calc {
  my ($p, $part) = @_;
  $part //= 1;
  my $ip = 0;
  while (1) {
    #print "$ip: @$p\n";
    my $op = $p->[$ip];
    if ($op == 1) {
      return if ($ip+3 >= scalar @$p);
      my ($i1, $i2, $o) = ($p->[++$ip], $p->[++$ip], $p->[++$ip]);
#      print "$i1 + $i2, $o\n";
      return unless ($i1 < scalar @$p && $i2 < scalar @$p && $o < scalar @$p);
      $p->[$o] = $p->[$i1] + $p->[$i2];
    } elsif ($op == 2) {
      return if ($ip+3 >= scalar @$p);
      my ($i1, $i2, $o) = ($p->[++$ip], $p->[++$ip], $p->[++$ip]);
#      print "$i1 * $i2, $o\n";
      return unless ($i1 < scalar @$p && $i2 < scalar @$p && $o < scalar @$p);
      $p->[$o] = $p->[$i1] * $p->[$i2];
    } elsif ($op == 99) {
      return $p->[0];
    } else {
      print "err\n";
      return;
    }
    $ip++;
  }
}

if (TEST) {
  my @test_cases =
    (
     [ ["1,0,0,0,99"], 2 ],
     [ ["2,3,0,3,99"], 2 ],
     [ ["2,4,4,5,99,0"], 2 ],
     [ ["1,1,1,4,99,5,6,0,99"], 30 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input($tc->[0]));
    assertEq("Test 1 [@{$tc->[0]}]", $res, $tc->[1]);
  }
}

$i->[1] = 12;
$i->[2] = 2;
my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i) = @_;
  my @init = @$i;
  for my $input (0..9999) {
    my $i = [@init];
    $i->[1] = int($input/100);
    $i->[2] = $input%100;
    my $res = calc($i);
    if (defined $res && $res == 19690720) {
      return $input;
    }
  }
  return -1;
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
