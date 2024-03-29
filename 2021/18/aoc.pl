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
my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub ex {
  my ($l) = @_;
  my $bc = 0;
  for (my $i = 0; $i < length($l)-1; $i++) {
    if ('[' eq substr $l, $i, 1) {
      $bc++;
      if ($bc == 5) {
        my $lb = $i;
        while (']' ne substr $l, $i, 1) {
          $lb = $i if ('[' eq substr $l, $i, 1);
          $i++;
        }
        my $rb = $i+1;
        my $pre = substr $l, 0, $lb;
        my $post = substr $l, $rb;
        my ($a, $b) = split/,/, (substr $l, $lb+1, ($rb-$lb-2));
        $pre =~ s/^.*\D\K(\d+)/$1+$a/e;
        $post =~ s/(\d+)/$b+$1/e;
        $l = $pre."0".$post;
        return $l;
      }
    } elsif (']' eq substr $l, $i, 1) {
      $bc--;
    }
  }
  return $l;
}

sub sp {
  my ($l) = @_;
  $l =~ s!(\d\d)!'['.(int($1/2)).','.(int(0.5+$1/2)).']'!e;
  return $l;
}

sub re {
  my ($l) = @_;
  while (1) {
    my $l2 = ex($l);
    if ($l2 ne $l) {
      $l = $l2;
      print "after explode: $l\n" if DEBUG;
      next;
    }
    my $l3 = sp($l);
    if ($l3 ne $l) {
      $l = $l3;
      print "after split:   $l\n" if DEBUG;
      next;
    }
    return $l;
  }
}

sub add {
  my ($a, $b) = @_;
  return re('['.$a.','.$b.']');
}

sub mag {
  my ($l) = @_;
  while ($l =~ s/\[(\d+),(\d+)\]/3*$1+2*$2/e) { }
  return $l;
}

sub calc {
  my ($in) = @_;
  #dd([$in],[qw/in/]);
  my $c = 0;
  my $p = $in->[0];
  for my $i (1..@$in-1) {
    $p = add($p, $in->[$i]);
  }
  return mag($p);
}

sub calc2 {
  my ($in) = @_;
  #dd([$in],[qw/in/]);
  my $max = 0;
  for my $i (0..@$in-1) {
    for my $j ($i+1..@$in-1) {
      my $s1 = add($in->[$i], re($in->[$j]));
      my $s2 = add($in->[$j], re($in->[$i]));
      my $m1 = mag($s1);
      my $m2 = mag($s2);
      my $m = max($m1, $m2);
      if ($max < $m) {
        $max = $m;
      }
    }
  }
  return $max;
}

testExplode() if TEST;
testSplit() if TEST;
testAdd() if TEST;
testMag() if TEST;

testPart1() if TEST;

print "Part 1: ", calc($i), "\n";

testPart2() if TEST;

print "Part 2: ", calc2($i2), "\n";

sub testExplode {
  my @test_cases =
    (
     [ "[[[[[9,8],1],2],3],4]", "[[[[0,9],2],3],4]" ],
     [ "[7,[6,[5,[4,[3,2]]]]]", "[7,[6,[5,[7,0]]]]" ],
     [ "[[6,[5,[4,[3,2]]]],1]", "[[6,[5,[7,0]]],3]" ],
     [ "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]" ],
     [ "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[7,0]]]]" ],
    );
  for my $tc (@test_cases) {
    my $res = ex($tc->[0]);
    assertEq("Test Explode [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testSplit {
  my @test_cases =
    (
     [ "[[[[0,7],4],[15,[0,13]]],[1,1]]", "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]", ],
     [ "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]", "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]" ],
    );
  for my $tc (@test_cases) {
    my $res = sp($tc->[0]);
    assertEq("Test Split [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testAdd {
  my @test_cases =
    (
     # first example
     [ "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]",
       "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]",
       "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]" ],
     [ "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]",
       "[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]",
       "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]" ],
     [ "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]",
       "[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]",
       "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]" ],
     [ "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]",
       "[7,[5,[[3,8],[1,4]]]]",
       "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]" ],
     [ "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]",
       "[[2,[2,2]],[8,[8,1]]]",
       "[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]" ],
     [ "[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]",
       "[2,9]",
       "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]" ],
     [ "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]",
       "[1,[[[9,3],9],[[9,0],[0,7]]]]",
       "[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]" ],
     [ "[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]",
       "[[[5,[7,4]],7],1]",
       "[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]" ],
     [ "[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]",
       "[[[[4,2],2],6],[8,7]]",
       "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]" ],
     # second example
     [ "[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]",
       "[[[5,[2,8]],4],[5,[[9,9],0]]]",
       "[[[[7,0],[7,8]],[[7,9],[0,6]]],[[[7,0],[6,6]],[[7,7],[0,9]]]]", ],
     [ "[[[[7,0],[7,8]],[[7,9],[0,6]]],[[[7,0],[6,6]],[[7,7],[0,9]]]]",
       "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]",
       "[[[[7,7],[7,7]],[[7,0],[7,7]]],[[[7,7],[6,7]],[[7,7],[8,9]]]]" ],
     [ "[[[[7,7],[7,7]],[[7,0],[7,7]]],[[[7,7],[6,7]],[[7,7],[8,9]]]]",
       "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]",
       "[[[[6,6],[6,6]],[[7,7],[7,7]]],[[[7,0],[7,7]],[[7,8],[8,8]]]]" ],
     [ "[[[[6,6],[6,6]],[[7,7],[7,7]]],[[[7,0],[7,7]],[[7,8],[8,8]]]]",
       "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]",
       "[[[[6,6],[7,7]],[[7,7],[8,8]]],[[[8,8],[0,8]],[[8,9],[9,9]]]]" ],
     [ "[[[[6,6],[7,7]],[[7,7],[8,8]]],[[[8,8],[0,8]],[[8,9],[9,9]]]]",
       "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]",
       "[[[[6,6],[7,7]],[[7,7],[7,0]]],[[[7,7],[8,8]],[[8,8],[8,9]]]]" ],
     [ "[[[[6,6],[7,7]],[[7,7],[7,0]]],[[[7,7],[8,8]],[[8,8],[8,9]]]]",
       "[[[[5,4],[7,7]],8],[[8,3],8]]",
       "[[[[7,7],[7,7]],[[7,7],[7,7]]],[[[0,7],[8,8]],[[8,8],[8,9]]]]" ],
     [ "[[[[7,7],[7,7]],[[7,7],[7,7]]],[[[0,7],[8,8]],[[8,8],[8,9]]]]",
       "[[9,3],[[9,9],[6,[4,9]]]]",
       "[[[[7,7],[7,7]],[[7,7],[8,8]]],[[[8,8],[0,8]],[[8,9],[8,7]]]]" ],
     [ "[[[[7,7],[7,7]],[[7,7],[8,8]]],[[[8,8],[0,8]],[[8,9],[8,7]]]]",
       "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]",
       "[[[[7,7],[7,7]],[[7,7],[7,7]]],[[[8,7],[8,7]],[[7,9],[5,0]]]]" ],
     [ "[[[[7,7],[7,7]],[[7,7],[7,7]]],[[[8,7],[8,7]],[[7,9],[5,0]]]]",
       "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]",
       "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]" ],
   );
  for my $tc (@test_cases) {
    my $res = add($tc->[0], $tc->[1]);
    assertEq("Test Add [$tc->[0] + $tc->[1]]", $res, $tc->[2]);
  }
}

sub testMag {
  my @test_cases =
    (
     [ "[9,1]", 29 ],
     [ "[1,9]", 21 ],
     [ "[[9,1],[1,9]]", 129 ],
     [ "[[1,2],[[3,4],5]]", 143 ],
     [ "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", 1384 ],
     [ "[[[[1,1],[2,2]],[3,3]],[4,4]]", 445 ],
     [ "[[[[3,0],[5,3]],[4,4]],[5,5]]", 791 ],
     [ "[[[[5,0],[7,4]],[5,5]],[6,6]]", 1137 ],
     [ "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", 3488 ],
     [ "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]", 4140 ],
    );
  for my $tc (@test_cases) {
    my $res = mag($tc->[0]);
    assertEq("Test Mag [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart1 {
  my @test_cases =
    (
     [ "test0.txt", 3488 ],
     [ "test1.txt", 4140 ],
     [ "input.txt", 3987 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test0.txt", 3805 ],
     [ "test1.txt", 3993 ],
     [ "input.txt", 4500 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
