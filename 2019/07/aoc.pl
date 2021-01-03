#!/usr/bin/perl
use warnings;# FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use IntCode;
#use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/permutations/;

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub try_phase {
  my ($prog, $phase) = @_;
  print "Testing phase: @$phase\n" if DEBUG;
  my @a = map { IntCode->new($prog,[$phase->[$_]]) } 0..4;
  my $done = 0;
  my $last;
  my $out;
  while ($done != 5) {
    for my $u (0..4) {
      if ($a[$u]->{done}) {
        print "unit $u halted\n" if DEBUG;
        $done++;
      } else {
        push @{$a[$u]->{i}}, $out if (defined $out);
        my $rc = $a[$u]->run();
        if ($rc == 2) {
          push @{$a[$u]->{i}}, 0;
          redo;
        }
        $out = shift @{$a[$u]->{o}};
        $last = $out if (defined $out);
        print "ran unit $u and received ", ($out//'nil')," ($rc)\n" if DEBUG;
        $done++ if ($rc);
      }
    }
  }
  return $last;
}

sub calc {
  my ($prog) = @_;
  my $iter = permutations([0..4]);
  my $max;
  while (my $p = $iter->next) {
    my $thrust = try_phase($prog, $p);
    $max = $thrust if (!defined $max || $max < $thrust);
  }
  return $max;
}

sub calc2 {
  my ($prog) = @_;
  my $iter = permutations([5..9]);
  my $max;
  while (my $p = $iter->next) {
    my $thrust = try_phase($prog, $p);
    $max = $thrust if (!defined $max || $max < $thrust);
  }
  return $max;
}

if (TEST) {

  for my $tc ([["3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"],
               [4,3,2,1,0], 43210 ],
              [["3,23,3,24,1002,24,10,24,1002,23,-1,23,".
                "101,5,23,23,1,24,23,23,4,23,99,0,0"], [0,1,2,3,4], 54321 ],
              [["3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,".
                "1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"],
               [1,0,4,3,2], 65210 ]) {
    my $ti = parse_input($tc->[0]);
    my $o = try_phase($ti, $tc->[1]);
    assertEq("Test try_phase [@{$tc->[0]}]", $o, $tc->[2]);
    assertEq("Test calc [@{$tc->[0]}]", calc($ti), $tc->[2]);
    exit;
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

if (TEST) {
  for my $tc ([["3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,".
                "27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"],
               [9,8,7,6,5], 139629729 ],
              [["3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,".
                "55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,".
                "1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,".
                "0,0,0,0,10"], [9,7,8,5,6], 18216]) {
    my $ti = parse_input($tc->[0]);
    my $o = try_phase($ti, $tc->[1]);
    assertEq("Test try_phase [@{$tc->[0]}]", $o, $tc->[2]);
    assertEq("Test calc [@{$tc->[0]}]", calc2($ti), $tc->[2]);
  }
}

my $part2 = calc2($i);
print "Part 2: ", $part2, "\n";
