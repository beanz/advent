#!/usr/bin/env perl
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

use constant {
  ORE_ORE => 0,
  CLAY_ORE => 1,
  OBS_ORE => 2,
  OBS_CLAY => 3,
  GEO_ORE => 4,
  GEO_OBS => 5,
  MAX_ORE => 6,

  P1_TIME => 24,
  P2_TIME => 32,
};

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my @ints = ($l =~ m!(\d+)!g);
    my $num = shift @ints;
    push @ints, max($ints[ORE_ORE], $ints[CLAY_ORE], $ints[OBS_ORE], $ints[GEO_ORE]);
    $m{$num} = \@ints;
  }
  return \%m;
}

sub score {
  my $s = 0;
  for (@_) {
    $s = 100 * $s + $_;
  }
  $s;
}

sub solve {
  my ($m, $n, $time, $prune_len) = @_;
  $prune_len //= $time <= 24 ? 200 : 8000;
  my $bp = $m->{$n};

  my @todo = ([$time, 0, 1, 0, 0, 0, 0, 0, 0, 0]);
  my $max = 0;
  my $prune_time = $time - 1;
  while (@todo) {
    if ($todo[0]->[0] == $prune_time) {
      @todo = sort {$b->[1] <=> $a->[1]} @todo;
      splice @todo, $prune_len;
      $prune_time--;
    }
    my $cur = shift @todo;
    my ($t, $score, $ro, $rc, $rob, $rg, $o, $c, $ob, $g) = @$cur;

    #print "$t: $score r=[$ro $rc $rob $rg] inv=[$o $c $ob $g]\n";
    if ($g > $max) {

      #print STDERR "Found new max $g > $max\n" if DEBUG;
      $max = $g;
    }
    if ($t == 0) {
      next;
    }

    my ($no, $nc, $nob, $ng) = ($o + $ro, $c + $rc, $ob + $rob, $g + $rg);
    my $nscore = score($ng, $rg, $nob, $rob, $nc, $no);
    push @todo, [$t - 1, $nscore, $ro, $rc, $rob, $rg, $no, $nc, $nob, $ng];
    if ($o >= $bp->[GEO_ORE] && $ob >= $bp->[GEO_OBS]) {
      push @todo,
        [
        $t - 1, $nscore,
        $ro, $rc, $rob, $rg + 1,
        $no - $bp->[GEO_ORE], $nc, $nob - $bp->[GEO_OBS], $ng
        ];
    }
    if ($o >= $bp->[OBS_ORE] && $c >= $bp->[OBS_CLAY] && $rob < $bp->[GEO_OBS]) {
      push @todo,
        [
        $t - 1, $nscore, $ro, $rc, $rob + 1, $rg,
        $no - $bp->[OBS_ORE], $nc - $bp->[OBS_CLAY], $nob, $ng
        ];
    }
    if ($o >= $bp->[CLAY_ORE] && $rc < $bp->[OBS_CLAY]) {
      push @todo,
        [
        $t - 1, $nscore, $ro, $rc + 1, $rob, $rg,
        $no - $bp->[CLAY_ORE], $nc, $nob, $ng
        ];
    }
    if ($o >= $bp->[ORE_ORE] && $ro < $bp->[MAX_ORE]) {
      push @todo,
        [
        $t - 1, $nscore, $ro + 1, $rc, $rob, $rg, $no - $bp->[ORE_ORE],
        $nc, $nob, $ng
        ];
    }
  }

  #print STDERR "\n" if DEBUG;
  return $max;
}

sub calc {
  my ($in) = @_;
  my $c = 0;
  for my $num (keys %$in) {
    $c += $num * solve($in, $num, P1_TIME);
  }
  return $c;
}

sub solve2 {
  my ($m, $n) = @_;
  solve($m, $n, P2_TIME);
}

sub calc2 {
  my ($in) = @_;
  my $p = 1;
  for (1, 2, 3) {
    next unless ($in->{$_});
    my $m = solve2($in, $_);
    print STDERR "$_ => $m\n" if DEBUG;
    $p *= $m;
  }
  return $p;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 33], ["input.txt", 1565],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (
    ["test1.txt", 1, 56],
    ["test1.txt", 2, 62],
    ["input.txt", 1, 29],
    ["input.txt", 2, 23],
    ["input.txt", 3, 16],
  );
  for my $tc (@test_cases) {
    my $res = solve2($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[2]);
  }
}
