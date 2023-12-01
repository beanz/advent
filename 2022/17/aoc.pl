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

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my @j = split //, $in->[0];
  my %m;
  for (0 .. 6) {
    $m{$_, 0} = '~';
  }
  return {
    m => \%m,
    top => 1,
    jet => \@j,
    jet_i => 0,
    rock => [0, 1, 2, 3, 4],
    rock_i => 0,
  };
}

sub pp {
  my ($m) = @_;
  for my $y (reverse 0 .. $m->{top}) {
    printf "%4d ", $y;
    for my $x (0 .. 6) {
      print $m->{m}->{$x, $y} // ".";
    }
    if ($y == $m->{top}) {
      print "<top";
    }
    print "\n";
  }
  pp_jet($m);
  print "next rock $m->{rock_i}\n";
  print "\n";
}

sub pp_jet {
  my ($m) = @_;
  for (0 .. 4) {
    print $m->{jet}->[($m->{jet_i} + $_) % @{$m->{jet}}];
  }
  print " $m->{jet_i}\n";
}

sub next_rock {
  my ($m) = @_;
  my $p = $m->{rock}->[$m->{rock_i}];
  $m->{rock_i}++;
  if ($m->{rock_i} == @{$m->{rock}}) {
    $m->{rock_i} = 0;
  }
  return $p;
}

sub jet {
  my ($m) = @_;
  my $p = $m->{jet}->[$m->{jet_i}];
  $m->{jet_i}++;
  if ($m->{jet_i} == @{$m->{jet}}) {
    $m->{jet_i} = 0;
  }
  return $p;
}

#my $m = {jet=>[split//,">><>"], jet_i=>0};
#for (0..10) {
#  print jet($m);
#}
#print "\n";
#exit;

my @rocks = (
  [[[0, 0], [1, 0], [2, 0], [3, 0]], 4, 1],
  [[[1, 2], [0, 1], [1, 1], [2, 1], [1, 0]], 3, 3],
  [[[2, 2], [2, 1], [0, 0], [1, 0], [2, 0]], 3, 3],
  [[[0, 3], [0, 2], [0, 1], [0, 0]], 1, 4],
  [[[0, 1], [1, 1], [0, 0], [1, 0]], 2, 2],
);

sub rock_hit {
  my ($m, $rn, $x, $y) = @_;
  my ($off, $w, $h) = @{$rocks[$rn]};
  return any {$m->{m}->{$x + $_->[X], $y + $_->[Y]}} @$off;
}

sub pp_rock {
  my ($m, $x, $y, $off, $h) = @_;
  my $nm = dclone($m);
  $nm->{m}->{$x + $_->[X], $y + $_->[Y]} = '@' for (@$off);
  $nm->{top} = max($m->{top}, $y + $h);
  pp($nm);
}

sub rock {
  my ($m, $rn) = @_;
  my ($off, $w, $h) = @{$rocks[$rn]};
  my ($x, $y) = (2, $m->{top} + 3);

  #pp_rock($m, $x, $y, $off, $h);
  while (1) {
    my $p = jet($m);
    if ($p eq '<' && $x > 0) {
      if (!rock_hit($m, $rn, $x - 1, $y)) {
        $x--;
      }
    } elsif ($p eq '>' && $x < 7 - $w) {
      if (!rock_hit($m, $rn, $x + 1, $y)) {
        $x++;
      }
    }
    if (!rock_hit($m, $rn, $x, $y - 1)) {
      $y--;

      #pp_rock($m, $x, $y, $off, $h);
    } else {
      last;
    }
  }
  $m->{m}->{$x + $_->[X], $y + $_->[Y]} = '#' for (@$off);
  $m->{top} = max($m->{top}, $y + $h);
}

sub key {
  my ($m) = @_;
  my $s = '';
  for my $y ($m->{top} - 5 .. $m->{top}) {
    for my $x (0 .. 6) {
      $s .= $m->{m}->{$x, $y} // ".";
    }
    $s .= "\n";
  }
  return $s . "!" . $m->{rock_i} . "!" . $m->{jet_i};
}

sub calc {
  my ($m) = @_;
  my $p1 = 0;
  my %seen;
  my $last = 1000000000000;
  my $round = 1;
  my $cycle_top;
  while ($round <= $last) {
    rock($m, next_rock($m));
    if ($round eq 2022) {
      $p1 = $m->{top} - 1;
    }
    my $k = key($m);
    if (!$cycle_top && exists $seen{$k} && $round >= 2022) {
      my ($prev_round, $prev_top) = @{$seen{$k}};
      print "Found cycle: $round && $prev_round / $m->{top} && $prev_top\n"
        if (DEBUG);
      my $top_d = $m->{top} - $prev_top;
      my $round_d = $round - $prev_round;
      my $n = int(($last - $round) / $round_d);
      $round += $n * $round_d;
      $cycle_top = $n * $top_d;
    }
    $seen{$k} = [$round, $m->{top}];
    $round++;

    #pp($m);
  }
  return [$p1, $cycle_top + $m->{top} - 1];
}

testParts() if (TEST);

my $res = calc($i);
print "Part 1: ", $res->[0], "\n";
print "Part 2: ", $res->[1], "\n";

sub testParts {
  my @test_cases =
    (["test1.txt", 3068, 1514285714288], ["input.txt", 3144, 1565242165201],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
