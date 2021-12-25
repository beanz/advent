#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.18;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_stuff;
my $i = $reader->($file);

# perl -lne 'if(/inp/){open F,">/tmp/prog".$n;$n++;};print F $_;' <input.txt
# for f in $(seq 1 13) ; do wdiff /tmp/prog /tmp/prog$f |grep -F '['; done
# shows us that each section varies with only three instructions. Slightly
# complicated by the fact that there are other 'add y N' instructions.

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my $r = { add_x => [], add_y => [], div_z => [] };
  my $y = 0;
  for (@$in) {
    if (/^div z (-?\d+)$/) {
      push @{$r->{div_z}}, $1;
    } elsif (/^add x (-?\d+)$/) {
      push @{$r->{add_x}}, $1;
    } elsif (/^add y (-?\d+)$/) {
      push @{$r->{add_y}}, $1 if (2 == ($y%3));
      $y++;
    }
  }
  die unless (14 == scalar @{$r->{add_x}});
  die unless (14 == scalar @{$r->{add_y}});
  die unless (14 == scalar @{$r->{div_z}});
  $r->{constraint} = {};
  my @stack = ();
  for my $j (0..13) {
    if ($r->{div_z}->[$j] != 1) {
      my $k = pop @stack;
      $r->{constraint}->{$j} = $k;
    } else {
      push @stack, $j;
    }
  }
  return $r;
}

#print "add_x: @{$i->{add_x}}\n";
#print "add_y: @{$i->{add_y}}\n";
#print "div_z: @{$i->{div_z}}\n";

sub run {
  my ($prog, $inp) = @_;
}

sub solve {
  my ($prog, $start, $inc) = @_;
  $start //= 9;
  $inc //= -1;
  my @a = ($start) x 14;
  for my $i (sort keys %{$prog->{constraint}}) {
    my $j = $prog->{constraint}->{$i};
    #print "checking $i $j constraint\n";
    while (1) {
      $a[$i] = $a[$j] + $prog->{add_y}->[$j] + $prog->{add_x}->[$i];
      if (0 < $a[$i] &&  $a[$i] <= 9) {
        last;
      }
      $a[$j] += $inc;
    }
  }
  return join "", @a;
}

sub calc {
  solve($_[0]);
}

sub calc2 {
  solve($_[0], 1, 1);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "input.txt", 96929994293996 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "input.txt", 41811761181141 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
