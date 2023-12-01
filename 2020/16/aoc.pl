#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my $i = read_lines($file);
my $i2 = read_lines($file);
#my $i = read_chunks($file);
#my $i2 = read_chunks($file);

sub calc {
  my ($lines) = @_;
  my $i = 0;
  my @field;
  while ($i < @$lines) {
    if ($lines->[$i] eq "") {
      last;
    }
    push @field, [split/(?:: |-| or )/, $lines->[$i]];
    $i++;
  }
  my @ticket;
  while ($i < @$lines) {
    if ($lines->[$i] =~ /,/) {
      @ticket = split/,/, $lines->[$i];
    }
    if ($lines->[$i] eq "nearby tickets:") {
      $i++;
      last;
    }
    $i++;
  }
  my $s = 0;
  my @valid;
  while ($i < @$lines) {
    my @v = split/,/, $lines->[$i];
    my $all_valid = 1;
    for my $v (@v) {
      my $valid = 0;
      for my $j (0..@field-1) {
        if ($v >= $field[$j]->[1] && $v <= $field[$j]->[2] ||
            $v >= $field[$j]->[3] && $v <= $field[$j]->[4]) {
          $valid = 1;
          last;
        }
      }
      unless ($valid) {
        $all_valid = 0;
        print "$i: bad field $v\n" if (DEBUG > 1);
        $s += $v;
      }
    }
    if ($all_valid) {
      push @valid, \@v;
    }
    $i++;
  }
  return $s;
}

sub calc2 {
  my ($lines, $test) = @_;
  $test //= 0;
  my $i = 0;
  my @field;
  while ($i < @$lines) {
    if ($lines->[$i] eq "") {
      last;
    }
    push @field, [split/(?:: |-| or )/, $lines->[$i]];
    $i++;
  }
  my @ticket;
  while ($i < @$lines) {
    if ($lines->[$i] =~ /,/) {
      @ticket = split/,/, $lines->[$i];
    }
    if ($lines->[$i] eq "nearby tickets:") {
      $i++;
      last;
    }
    $i++;
  }
  my $s = 0;
  my @valid;
  while ($i < @$lines) {
    my @v = split/,/, $lines->[$i];
    my $all_valid = 1;
    for my $v (@v) {
      my $valid = 0;
      for my $j (0..@field-1) {
        if ($v >= $field[$j]->[1] && $v <= $field[$j]->[2] ||
            $v >= $field[$j]->[3] && $v <= $field[$j]->[4]) {
          $valid = 1;
          last;
        }
      }
      unless ($valid) {
        $all_valid = 0;
        $s += $v;
      }
    }
    if ($all_valid) {
      push @valid, \@v;
    }
    $i++;
  }
  unshift @valid, \@ticket;
  if (DEBUG) {
    dd([\@field]);
    print "@ticket\n";
    print ~~@valid, "\n";
    dd([\@valid]) if (DEBUG > 1);
  }
  my %possible;
  my $target = ~~@valid;
  for my $col (0..@ticket-1) {
    for my $f (@field) {
      my $vc = 0;
      for my $v (@valid) {
        if ($v->[$col] >= $f->[1] && $v->[$col] <= $f->[2] ||
            $v->[$col] >= $f->[3] && $v->[$col] <= $f->[4]) {
          $vc++;
        }
      }
      if ($vc == $target) {
        print "Found: $f->[0] at $col $ticket[$col]\n" if DEBUG;
        $possible{$f->[0]}->{$col}++;
      }
    }
  }
  my %final;
  my $p2 = 1;
  dd([\%possible]) if (DEBUG);
  while (1) {
    my @k =
      sort { (scalar keys %{$possible{$a}})
             <=> (scalar keys %{$possible{$b}}) } keys %possible;
    if ((scalar keys %{$possible{$k[0]}}) == 1) {
      my $col = (keys %{$possible{$k[0]}})[0];
      if (DEBUG) {
        print "Definite $k[0] is $col\n";
        print "Our value: $k[0] = $ticket[$col]\n";
      }
      if ($k[0] =~ /^depart/ || $test) {
        $p2 *= $ticket[$col];
      }
      for my $k (keys %possible) {
        delete $possible{$k}->{$col};
      }
      delete $possible{$k[0]};
      if ((scalar keys %possible) == 0) {
        last;
      }
    } else {
      die "Unable to solve it\n";
    }
  }
  return $p2;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2, $file eq "test2.txt"), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 71 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_lines($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test2.txt", 1716 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_lines($tc->[0]), 1);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
