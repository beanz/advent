#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;

sub calc {
  my ($s) = @_;
  my $l = index $s, "\n";
  while ($s =~ s/[\+\|].{$l}\K\./|/s || # pour down
         $s =~ s/\.\|(.{$l})([\#~])/\|\|$1$2/s || # pour left
         $s =~ s/\|\.(.{@{[$l-1]}})([\#~])/\|\|$1$2/s || # pour right
         $s =~ s/([\#\~])\|([|]*)\#/$1~$2\#/s) { }
  my $ss = $s;
  $ss =~ s/^.*?\n([^\n]*#)/$1/; # chop off lines before y min
  $ss =~ s/(#[^\n]*\n)\K[^#]*$//; # chop off lines after y max
  my $water = ~~($ss=~y/~\|//);
  my $still = ~~($ss=~y/~//);
  return [$water, $still]
}

my @test_input = split/\n/, <<'EOF';
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
EOF
my $test_input = parse_input(\@test_input);
print $test_input, "\n" if DEBUG;

@test_input = split/\n/, <<'EOF';
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=2..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
EOF
my $test_input2 = parse_input(\@test_input);
print $test_input2, "\n" if DEBUG;

if (TEST) {
  my $res = calc($test_input);
  print "Test 1a: @$res == 57 & 29\n";
  die "failed\n" unless ($res->[0] == 57 && $res->[1] == 29);

  $res = calc($test_input2);
  print "Test 1b: @$res == 56 & 29\n";
  die "failed\n" unless ($res->[0] == 56 && $res->[1] == 29);
}

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

my $res = calc($i);
print "Part 1: ", $res->[0], "\n";
print "Part 2: ", $res->[1], "\n";
exit;

sub parse_input {
  my ($lines) = @_;
  my %clay;
  my @bb = ();
  for my $l (@$lines) {
    if ($l =~ m!x=(\d+), y=(\d+)..(\d+)!) {
      $clay{$_}->{$1} = '#' for ($2..$3);
      minmax_xy(\@bb, $1, $2);
      minmax_xy(\@bb, $1, $3);
    } elsif ($l =~ m!y=(\d+), x=(\d+)..(\d+)!) {
      $clay{$1}->{$_} = '#' for ($2..$3);
      minmax_xy(\@bb, $2, $1);
      minmax_xy(\@bb, $3, $1);
    } else {
      die "invalid input: $l\n";
    }
  }
  my $grid =
    pretty_grid([$bb[MINX] - 1, $bb[MINY] - 1],
                [$bb[MAXX] + 1, $bb[MAXY] + 1],
                sub {
                  my ($x, $y) = @_;
                  my $sq;
                  if ($x == 500 && $y == $bb[MINY] - 1) {
                    $sq = '+';
                  } elsif (exists $clay{$y}->{$x}) {
                    $sq = $clay{$y}->{$x};
                  } else {
                    $sq = '.';
                  }
                  return $sq;
                },
                undef, undef, 0);
  return $grid;
}
