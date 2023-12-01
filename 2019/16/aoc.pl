#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

$|=1;
my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split //, $lines->[0]];
}

sub calc {
  my ($s) = @_;
  my @REP = (0, 1, 0, -1);
  my @o;
  for my $i (1..@$s) {
    my $n = 0;
    for my $j (0..@$s-1) {
      my $di = int((1+$j)/$i);
      my $mul = $REP[$di%4];
      my $d = $s->[$j]*$mul;
      $n += $d;
      #print $s->[$j], "*", $mul, " [$di] + " if DEBUG;
    }
    $n = abs($n)%10;
    #print "= $n\n" if DEBUG;
    push @o, $n;
  }
  return \@o;
}

sub digits {
  my ($s, $d, $offset) = @_;
  return substr(join('',@$s), $offset//0, $d);
}

sub part1 {
  my ($s, $phases) = @_;
  for my $phase (1..$phases) {
    $s = calc($s);
    print "Phase $phase Signal: ", digits($s, 8), "\r" if DEBUG;
  }
  print "\n" if DEBUG;
  return digits($s,8);
}

sub offset {
  my ($s, $digits) = @_;
  my $r = 0;
  for my $i (0..$digits-1) {
    $r *= 10;
    $r += $s->[$i];
  }
  return $r;
}

sub calc2 {
  my ($s) = @_;
  my $sum = sum(@$s);
  my @o;
  for my $i (0..@$s-1) {
    my $n = abs($sum)%10;
    push @o, $n;
    $sum -= $s->[$i];
  }
  return \@o;
}

sub part2 {
  my ($s) = @_;
  my $offset = offset($s, 7);
  my @s10000 = (@$s) x 10000;
  splice @s10000, 0, $offset;
  $s = \@s10000;
  my $phases = 100;
  for my $phase (1..$phases) {
    $s = calc2($s);
    print "Phase $phase Signal: ", digits($s, 8), "\r" if DEBUG;
  }
  print "\n" if DEBUG;
  return digits($s, 8);
}

if (TEST) {
  my @test_cases =
    (
     [ "test1a.txt", 4, "01029498" ],
     [ "test1b.txt", 100, "24176176" ],
     [ "test1c.txt", 100, "73745418" ],
     [ "test1d.txt", 100, "52432133" ],
    );
  for my $tc (@test_cases) {
    my $res = part1(parse_input(read_lines($tc->[0])), $tc->[1]);
    assertEq("Test 1 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }

  my @test_cases2 =
    (
     [ "test2a.txt", "84462026" ],
     [ "test2b.txt", "78725270" ],
     [ "test2c.txt", "53553731" ],
    );
  for my $tc (@test_cases2) {
    my $res = part2(parse_input(read_lines($tc->[0])));
    assertEq("Test 2 [$tc->[0] x 100]", $res, $tc->[1]);
  }
}

my $part1 = part1($i, 100);
print "Part 1: ", $part1, "\n";

$i = parse_input(\@i); # reset input
print "Part 2: ", part2($i), "\n";
