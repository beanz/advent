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
#my $reader = \&read_stuff;
my $reader = \&read_lines;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
 return { l => $in, d => [ map { eval $_ } @$in ] };
}

sub areduce {
  my ($n, $d) = @_;
  $d //= 0;
  return $n unless (ref $n);
  return [areduce($n->[0], $d+1), areduce($n->[1], $d+1)];
}

sub re0 {
  my ($l) = @_;
  if ($l =~ /^(.*?\[.*?\[.*?\[.*?)\[(\d+),(\d+)\](.*)$/) {
    my ($pre, $a, $b, $post) = ($1, $2, $3, $4);
    print "! $pre / $a / $b / $post\n";
    $pre =~ s/^.*\D\K(\d+)/$1+$a/e;
    print "0 $pre / $a / $b / $post\n";
    $post =~ s/(\d+)/$b+$1/e;
    print "1 $pre / $a / $b / $post\n";
    $l = $pre."0".$post;
    print "2 $l\n";
  }
}

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
        #print "! ", $pre, " * ", $a, " ! ", $b, " * ", $post, "\n";
        $pre =~ s/^.*\D\K(\d+)/$1+$a/e;
        $post =~ s/(\d+)/$b+$1/e;
        $l = $pre."0".$post;
        #print "? $l\n";
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
      next;
    }
    my $l3 = sp($l);
    if ($l3 ne $l) {
      $l = $l3;
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
  my $p = re($in->[0]);
  for my $i (0..@$in-1) {
    $p = add($p, re($in->[$i]));
  }
  print "F: $p\n";
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

testExplode();
testSplit();
testAdd();
testMag();


testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

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
    );
  for my $tc (@test_cases) {
    my $res = add($tc->[0], $tc->[1]);
    assertEq("Test Mag [$tc->[0] + $tc->[1]]", $res, $tc->[2]);
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
     [ "test1.txt", 10 ],
     [ "input.txt", 307 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 1, 15 ],
     [ "test1.txt", 2, 12 ],
     [ "test1.txt", 10, 37 ],
     [ "test1.txt", 100, 2208 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 2 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}
