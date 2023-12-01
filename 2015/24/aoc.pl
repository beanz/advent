#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant
  {
   LEFT => 0,
   PICKED => 1,
   ITEMS => 0,
   LEN => 1,
   PROD => 2
  };

my @i = @{read_lines(shift//"input.txt")};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  my @s = map { 0+$_ } @$lines;
  my $sum = sum(@s);
  return { items => [sort { $b <=> $a } @s], sum => $sum };
}

sub all_combinations {
  my ($k, $remaining, $prefix) = @_;
  print STDERR "AC: $remaining from @$k\n" if DEBUG;
  my @todo = ([$k, []]);
  my @res;
  my $shortest;
  while (@todo) {
    my $next = shift @todo;
    #print "Checking ", "@$next\n" if DEBUG;
    my @left = @{$next->[LEFT]};
    my $sum = sum(@{$next->[PICKED]}) // 0;
    unless (@left) {
      if ($remaining == $sum) {
        print STDERR "  valid set ", (join ',', @{$next->[PICKED]}), "\n"
          if DEBUG;
        push @res, $next->[PICKED];
        if (!defined $shortest || $shortest > scalar @{$next->[PICKED]}) {
          print STDERR "  new shortest\n" if DEBUG;
          $shortest = @{$next->[PICKED]}
        }
      } else {
        print STDERR "  too small set ", (join ',', @{$next->[PICKED]}), "\n"
          if DEBUG;
      }
      next;
    }
    my $cap = shift @left;
    if (defined $shortest && $shortest < @{$next->[PICKED]}) {
      print STDERR "  set too big ", scalar @{$next->[PICKED]}, "\n"
        if DEBUG;
      next;
    }
    if (($cap + $sum) == $remaining) {
      print STDERR "  valid set $cap,", (join ',', @{$next->[PICKED]}), "\n"
        if DEBUG;
      push @res, [$cap, @{$next->[PICKED]}];
      if (!defined $shortest || $shortest > scalar @{$next->[PICKED]}) {
        print STDERR "  new shortest\n" if DEBUG;
        $shortest = @{$next->[PICKED]}
      }
    } elsif (($cap + $sum) < $remaining) {
      print STDERR "  adding $cap and @{$next->[PICKED]}\n" if DEBUG;
      push @todo, [ [@left], [$cap, @{$next->[PICKED]}] ];
    }
    print STDERR "  adding @{$next->[PICKED]}\n" if DEBUG;
    push @todo, [ [@left], [@{$next->[PICKED]}] ];
  }
  return \@res;
}

sub calc {
  my ($i, $groups) = @_;
  $groups //= 3;
  my $combinations = all_combinations($i->{items}, $i->{sum}/$groups);
  my @sortable = map { [ $_, scalar(@$_), product(@$_) ] } @$combinations;
  my @sorted =
    sort { $a->[LEN] <=> $b->[LEN] || $a->[PROD] <=> $b->[PROD] } @sortable;
  print STDERR "First set @{$sorted[0]->[ITEMS]}\n" if DEBUG;
  return $sorted[0]->[PROD];
}

my $test_input;
$test_input = parse_input([split/\n/, <<'EOF']);
1
2
3
4
5
7
8
9
10
11
EOF
#dd([$test_input],[qw/test_input/]);

if (TEST) {
  my $res;
  $res = calc($test_input);
  assertEq("Test 1", $res, 99);
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($i) = @_;
  return ~~keys %$i;
}

if (TEST) {
  my $res;
  $res = calc($test_input, 4);
  assertEq("Test 2", $res, 44);
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc($i, 4), "\n";
