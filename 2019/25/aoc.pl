#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use IntCode;
use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw(combinations);

my $i = parse_input(read_lines("input.txt"));

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

my @commands =
  ("", # hull breach
   "south", "take fixed point", "north", "west", "west",
   "west", "take hologram", "east", "north", "west", "east", "east",
   "west","south","east","east","north",
   "take candy cane","west", "take antenna",
   "south", "take whirled peas", "north",
   "west", "take shell",
   "east", "east", "north",
   "north", "take polygon", "south",
   "west", "take fuel cell","west",
   "inv",
  );

my @items =
  (
   "hologram","shell","whirled peas","fuel cell",
   "fixed point","polygon","antenna","candy cane",
   );

my @combos;
for my $n (1..@items) {
  push @combos, combinations(\@items, $n);
}
@combos = ["shell", "fixed point", "polygon", "candy cane"];

sub calc {
  my ($prog) = @_;
  my $ic = IntCode->new($prog, [$i]);
  my $auto;
  my $all_output = "";
  while (!$ic->{done}) {
    my $rc = $ic->run();
    if ($rc == 0) {
      my $s = "";
      while (@{$ic->{o}}) {
        my $ch = shift @{$ic->{o}};
        $s .= chr($ch);
      }
      print $s if DEBUG;
      $all_output .= $s;
      if ($all_output =~ /by typing (\d+) on the keypad/) {
        return $1
      }
    } elsif ($rc == 2) {
      if ($auto) {
        my $comb = shift @combos;
        my $inp = "";
        for my $i (@items) {
          $inp .= "drop $i\n";
        }
        for my $i (@$comb) {
          $inp .= "take $i\n";
        }
        $inp .= "west\n";
        push @{$ic->{i}}, map { ord $_ } split//, $inp;
      } else {
        my $inp;
        if (@commands) {
          $inp = shift @commands;
          $inp .= "\n";
        } else {
          $inp = <>;
        }
        push @{$ic->{i}}, map { ord $_ } split//, $inp;
        if ($inp eq "inv\n") {
          $auto = 1;
        }
      }
    }
  }
  return -1;
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";
