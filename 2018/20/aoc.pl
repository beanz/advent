#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant { DIST => 2 };

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return $lines->[0];
}

sub rooms {
  my ($p, $cutoff) = @_;
  $cutoff //= 1000;
  my %r = ();
  rooms_aux($p, 0, 0, \%r, '');
  print STDERR pp(\%r), "\n" if DEBUG;
  my @todo = ([0, 0, 0]);
  my $vc = visit_checker();
  my $max;
  my $count = 0;
  while (@todo) {
    my $c = shift @todo;
    print STDERR pp(\%r, 'path checking', [$c->[0], $c->[1]]), "\n" if DEBUG;
    for my $d (qw/N S E W/) {
      next unless (doorAt(\%r, $c->[X], $c->[Y], $d));
      my $n = move($c->[X], $c->[Y], $d);
      next if $vc->(@$n); # visited via shorter path
      my $new_dist = $c->[DIST] + 1;
      if (!defined $max || $max < $new_dist) {
        $max = $new_dist;
      }
      if ($new_dist >= $cutoff) {
        $count++;
      }
      push @todo, [@$n, $new_dist];
    }
  }
  return [$max, $count, \%r];
}

sub offset {
  { 'N' => [0,-1], 'S' => [0,1], 'E' => [1,0], 'W' => [-1,0] }->{$_[0]}
}

sub opposite {
  my $s = $_[0];
  $s =~ y/NSEW/SNWE/;
  $s;
}

sub add_door {
  my ($r, $x, $y, $d, $xn, $yn) = @_;
  unless (exists $r->{$y}->{$x}) {
    $r->{$y}->{$x} = {};
  }
  unless (exists $r->{$yn}->{$xn}) {
    $r->{$yn}->{$xn} = {};
  }
  $r->{$y}->{$x}->{$d} = $r->{$yn}->{$xn};
  $r->{$yn}->{$xn}->{opposite($d)} = $r->{$y}->{$x};
  $r->{minx} = min($x, $xn, exists $r->{minx} ? $r->{minx} : ());
  $r->{maxx} = max($x, $xn, exists $r->{maxx} ? $r->{maxx} : ());
  $r->{miny} = min($y, $yn, exists $r->{miny} ? $r->{miny} : ());
  $r->{maxy} = max($y, $yn, exists $r->{maxy} ? $r->{maxy} : ());
}

sub roomAt {
  my ($r, $x, $y) = @_;
  return $r->{$y}->{$x};
}

sub doorAt {
  my ($r, $x, $y, $d) = @_;
  my $room = roomAt($r, $x, $y) or return;
  return $room->{$d};
}

sub move {
  my ($x, $y, $d) = @_;
  my $o = offset($d);
  return [$x + $o->[X], $y + $o->[Y]];
}

sub pp {
  my ($r, $m, $h) = @_;
  my $s = '';
  if (defined $m) {
    $s .= $m;
    if (defined $h) {
      $s .= sprintf " at %d, %d\n", @$h;
    } else {
      $s .= "\n";
    }
  }
  my $s1;
  for my $y ($r->{miny}..$r->{maxy}) {
    $s1 = '';
    my $s2 = '';
    for my $x ($r->{minx}..$r->{maxx}) {
      $s1 .= '#'.(doorAt($r, $x,$y,'N') ? '-' : '#');
      my $sq = ($x == 0 && $y ==0 ? 'X' : roomAt($r, $x, $y) ? '.' : '#');
      if (defined $h && $h->[X] == $x && $h->[Y] == $y) {
        $sq = red($sq);
      }
      $s2 .= (doorAt($r, $x, $y, 'W') ? '|' : '#').$sq;
    }
    $s .= $s1."#\n";
    $s .= $s2."#\n";
  }
  $s .= '#' x (1+length $s1);
  return $s;
}

sub rooms_aux {
  my ($p, $x, $y, $rooms) = @_;
  my @stack = ();
  while ($p =~ s/^\^?(.)//) {
    my $c = $1;
    if ($c =~ /^[NSEW]$/) {
      my $o = offset($c);
      my $xn= $x + $o->[X];
      my $yn= $y + $o->[Y];
      add_door($rooms, $x, $y, $c, $xn, $yn);
      print STDERR pp($rooms, 'adding door', [$xn, $yn]), "\n" if DEBUG;
      $x = $xn;
      $y = $yn;
    } elsif ($c eq '(') {
      unshift @stack, [$x, $y];
    } elsif ($c eq '|') {
      $x = $stack[0]->[X];
      $y = $stack[0]->[Y];
    } elsif ($c eq ')') {
      shift @stack;
    } elsif ($c eq '$') {
      if (@stack) {
        die "Stack not empty at end: @stack\n";
      }
    } else {
      die "unexpected $c with $p remaining\n";
    }
  }
}

sub calc {
  my ($i) = @_;
  return rooms($i)->[0];
}

my @test_cases =
  (
   ['^WNE$', 3, 0],
   ['^ENWWW$', 5, 0],
   ['^ENWWW(NEEE|SSE(EE|N))$', 10, 8],
   ['^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$', 18, 18],
   ['^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$', 23, 29],
   ['^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$',
    31, 42],
  );

if (TEST) {
  for my $tc (@test_cases) {
    my $res = calc($tc->[0]);
    print "Test 1: $res == $tc->[1]\n";
    die "failed\n" unless ($res == $tc->[1]);
  }
}

print "Part 1: ", calc($i), "\n";

sub calc2 {
  my ($i, $cutoff) = @_;
  return rooms($i, $cutoff)->[1];
}

if (TEST) {
  for my $tc (@test_cases) {
    my $res = calc2($tc->[0], 7);
    print "Test 2: $res == $tc->[2]\n";
    die "failed\n" unless ($res == $tc->[2]);
  }
}

print "Part 2: ", calc2($i), "\n";
