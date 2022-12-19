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

use constant {
  ORE => 0,
  CLY => 1,
  CLAY => 1,
  OBS => 2,
  GEO => 3,

  P1_TIME => 24,
};

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m;
  for my $i (0 .. (@$in - 1)) {
    my $l = $in->[$i];
    my @ints = ($l =~ m!(\d+)!g);
    my $num = shift @ints;
    my @costs = (
      $ints[0],    # ore
      $ints[1],    # clay
      [$ints[2], $ints[3]],    # obsidian
      [$ints[4], $ints[5]],    # geode
    );
    $m{$num} = \@costs;
  }
  return \%m;
}

my @TYPES = (ORE, CLY, OBS, GEO);
my @NAMES = (qw/ore cly obs geo/);
sub tn {$NAMES[$_[0]]}

sub score {
  my $s = 0;
  for (@_) {
    $s = 100 * $s + $_;
  }
  $s;
}

sub solve {
  my ($m, $n, $time, $prune_len) = @_;
  $prune_len //= 2000;
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
    if ($o >= $bp->[GEO]->[0] && $ob >= $bp->[GEO]->[1]) {

      #print "can buy geode robot\n";
      push @todo,
        [
        $t - 1, $nscore, $ro, $rc,
        $rob, $rg + 1, $no - $bp->[GEO]->[0], $nc,
        $nob - $bp->[GEO]->[1], $ng
        ];
    }
    if ($o >= $bp->[OBS]->[0] && $c >= $bp->[OBS]->[1]) {

      #print "can buy obsidian robot\n";
      push @todo,
        [
        $t - 1, $nscore, $ro, $rc, $rob + 1, $rg,
        $no - $bp->[OBS]->[0],
        $nc - $bp->[OBS]->[1],
        $nob, $ng
        ];
    }
    if ($o >= $bp->[CLAY]) {

      #print "can buy clay robot\n";
      push @todo,
        [
        $t - 1, $nscore, $ro, $rc + 1, $rob, $rg, $no - $bp->[CLAY],
        $nc, $nob, $ng
        ];
    }
    if ($o >= $bp->[ORE]) {

      #print "can buy ore robot\n";
      push @todo,
        [
        $t - 1, $nscore, $ro + 1, $rc, $rob, $rg, $no - $bp->[ORE],
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
    $c += $num * solve($in, $num, 24);
  }
  return $c;
}

sub solve2 {
  my ($m, $n) = @_;
  solve($m, $n, 32, 20000);
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
