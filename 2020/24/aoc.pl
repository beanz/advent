#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_hex;
my $i = $reader->($file);
my $i2 = $reader->($file);

{
  package HT;
  use constant { _Q => 0, _R => 1,
                 DIRS => { 'e' => [1, 0],
                           'se' => [0,-1],
                           'sw' => [-1,-1],
                           'w' => [-1, 0],
                           'nw' => [0, 1],
                           'ne' => [1,1],
                         },
               };
  sub new {
    my ($pkg, $q, $r) = @_;
    $q //= 0;
    $r //= 0;
    bless [$q, $r], $pkg;
  }
  sub newK {
    my ($pkg, $k) = @_;
    bless [split/,/,$k], $pkg;
  }
  sub K {
    join ',', @{$_[0]};
  }
  sub Q {
    $_[0]->[_Q];
  }
  sub R {
    $_[0]->[_R];
  }
  sub move {
    my ($self, $m) = @_;
    while ($m =~ s/^(e|se|sw|w|nw|ne)//) {
      my ($dq, $dr) = @{ DIRS->{$1} };
      $self->[_Q] += $dq;
      $self->[_R] += $dr;
    }
    die "Invalid move: $m\n" if ($m);
  }
  sub nb {
    my ($self) = @_;
    my $dirs = DIRS;
    return map {
      HT->new($self->Q+$_->[_Q], $self->R+$_->[_R])
    } values %$dirs;
  }
  1;
}

sub read_hex {
  my ($file) = @_;
  my $in = read_lines($file);
  my %b;
  for my $l (@$in) {
    my $ht = HT->new();
    $ht->move($l);
    my $k = $ht->K;
    if (exists $b{$k}) {
      delete $b{$k};
    } else {
      $b{$ht->K} = $ht;
    }
  }
  return \%b;
}

sub calc {
  my ($in) = @_;
  return scalar keys %{$in};
}

sub calc2 {
  my ($in, $days) = @_;
  $days //= 100;
  my $cur = $in;
  for my $d (1..$days) {
    my %done;
    my $next = {};
    for my $cht (values %$cur) {
      for my $ht ($cht, $cht->nb) {
        my $k = $ht->K;
        next if (exists $done{$k});
        $done{$k}++;
        my $nc = 0;
        for my $nt ($ht->nb) {
          $nc += exists $cur->{$nt->K};
        }
        if ((exists $cur->{$k} && !($nc == 0 || $nc > 2)) ||
            (!exists $cur->{$k} && $nc == 2)) {
          $next->{$k} = $ht;
        }
      }
    }
    print "Day $d: ", scalar keys %$next, "\n" if DEBUG;
    $cur = $next;
  }
  return scalar keys %$cur;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

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
