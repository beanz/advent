#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

use constant { Z => 2, ZZ => 3 };
my @i = <>;
chomp @i;

my $i = parse_input(\@i);
#dd([$i],[qw/i/]);

sub parse_input {
  my ($lines) = @_;
  my @s;
  for my $l (@$lines) {
    $l =~ s/^\s+//;
    my @p = split /,/, $l;
    die "Invalid line: $l\n" unless (@p == 4);
    push @s, \@p;
  }
  return \@s;
}

sub manhattanDistance4D {
  my ($p1, $p2) = @_;
  return
    abs($p1->[X]-$p2->[X]) + abs($p1->[Y]-$p2->[Y]) +
    abs($p1->[Z]-$p2->[Z]) + abs($p1->[ZZ]-$p2->[ZZ]);
}

sub inConstellation {
  my ($c, $s) = @_;
  for my $ss (@$c) {
    if (manhattanDistance4D($ss, $s) <= 3) {
      return 1;
    }
  }
  return;
}

sub pps {
  my ($s) = @_;
  return '['.(join ',', @$s).']';
}

sub ppc {
  my ($c) = @_;
  return join ' ', sort map { pps($_) } @$c;
}

sub pp {
  my ($cc) = @_;
  my $s = "";
  for my $i (0..@$cc-1) {
    $s .= sprintf "%d: %s\n", $i, ppc($cc->[$i]);
  }
  return $s;
}

sub calc {
  my ($i) = @_;
  my @c;
 LL:
  for my $j (0..@$i-1) {
    my @possible;
    # highest number first to order possible correctly for merging
    for my $k (reverse 0..$#c) {
      if (inConstellation($c[$k], $i->[$j])) {
        push @possible, $k;
      }
    }
    if (@possible) {
      if (@possible == 1) {
        push @{$c[$possible[0]]}, $i->[$j];
      } else {
        # highest first to avoid messing with indices
        for my $k (0..$#possible-1) {
          print STDERR
            "Combining constellation $possible[$k] with $possible[$k+1]\n"
            if DEBUG;
          push @{$c[$possible[$k+1]]}, @{$c[$possible[$k]]}, $i->[$j];
          splice @c, $possible[$k], 1;
        }
      }
    } else {
      push @c, [$i->[$j]];
    }
  }
  print STDERR pp(\@c) if DEBUG;
  return ~~@c;
}

my @test_cases;
push @test_cases, parse_input([split/\n/, <<'EOF']);
0,0,0,0
3,0,0,0
0,3,0,0
0,0,3,0
0,0,0,3
0,0,0,6
9,0,0,0
12,0,0,0
EOF

push @test_cases, parse_input([split/\n/, <<'EOF']);
-1,2,2,0
0,0,2,-2
0,0,0,-2
-1,2,0,0
-2,-2,-2,2
3,0,2,-1
-1,3,2,2
-1,0,-1,0
0,2,1,-2
3,0,0,0
EOF

push @test_cases, parse_input([split/\n/, <<'EOF']);
1,-1,0,1
2,0,-1,0
3,2,-1,0
0,0,3,1
0,0,-1,-1
2,3,-2,0
-2,2,0,0
2,-2,0,-1
1,-1,0,-1
3,2,0,2
EOF

push @test_cases, parse_input([split/\n/, <<'EOF']);
1,-1,-1,-2
-2,-2,0,1
0,2,1,3
-2,3,-2,1
0,2,3,-2
-1,-1,1,-2
0,-2,-1,0
-2,2,3,-1
1,2,2,0
-1,-2,0,-2
EOF

if (TEST) {
  my @answers = (2, 4, 3, 8);
  for my $i (0..$#answers) {
    my $res = calc($test_cases[$i]);
    assertEq("Test 1.$i", $res, $answers[$i]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";
