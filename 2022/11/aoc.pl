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

my $file = shift // input_file();

my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_guess($file);
  my @m;
  for my $i (0 .. (@$in - 1)) {
    my %r;
    my $l = $in->[$i];
    $r{n} = $i;
    if ($l->[1] =~ /Starting items: (.*)$/) {
      $r{i} = [split /,\s+/, $1];
    } else {
      die "unexpected items: $l->[1]";
    }
    if ($l->[2] =~ /old \+ (\d+)/) {
      my $n = $1;
      $r{o} = sub {$_[0] + $n};
    } elsif ($l->[2] =~ /old \* (\d+)/) {
      my $n = $1;
      $r{o} = sub {$_[0] * $n};
    } elsif ($l->[2] =~ /old \* old/) {
      $r{o} = sub {$_[0] * $_[0]};
    } else {
      die "unexpected op: $l->[2]";
    }
    if ($l->[3] =~ /divisible by (\d+)/) {
      my $n = $1;
      $r{div} = $n;
      $r{t} = sub {0 == ($_[0] % $n)};
    } else {
      die "unexpected test $l->[3]";
    }
    if ($l->[4] =~ /true: throw to monkey (\d+)/) {
      $r{tt} = $1;
    } else {
      die "unexpected true $l->[4]";
    }
    if ($l->[5] =~ /false: throw to monkey (\d+)/) {
      $r{tf} = $1;
    } else {
      die "unexpected true $l->[5]";
    }
    $r{c} = 0;
    push @m, \%r;
  }
  return \@m;
}

sub pp {
  my ($in) = @_;
  for my $m (@$in) {
    print "Monkey $m->{n}: ", join ",", @{$m->{i}}, " $m->{c}\n";
  }
}

sub gcd {
  my ($a, $b) = @_;
  $a = abs($a);
  $b = abs($b);
  ($a, $b) = ($b, $a) if $a > $b;
  while ($a) {
    ($a, $b) = ($b % $a, $a);
  }
  return $b;
}

sub lcm {
  my ($a, $b) = @_;
  ($a && $b) and $a / gcd($a, $b) * $b or 0;
}

sub calc {
  my ($in, $rounds, $div) = @_;
  $rounds //= 20;
  $div //= 3;
  my $lcm = 1;
  for my $m (@$in) {
    $lcm = lcm($lcm, $m->{div});
  }
  my $reduce = sub {int($_[0] / $div)};
  if ($div == 0) {
    $reduce = sub {$_[0] % $lcm}
  }
  for my $rn (1 .. $rounds) {
    for my $m (@$in) {
      while (@{$m->{i}}) {
        my $i = shift @{$m->{i}};
        $m->{c}++;
        my $w = $i;
        $w = $m->{o}->($w);
        $w = $reduce->($w);
        my $t = $m->{t}->($w);
        if ($t) {
          push @{$in->[$m->{tt}]->{i}}, $w;
        } else {
          push @{$in->[$m->{tf}]->{i}}, $w;
        }
      }
    }

    #pp($in);
  }
  my @c = sort {$b <=> $a} map {$_->{c}} @$in;
  return $c[0] * $c[1];
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc($i2, 10000, 0), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 10605], ["input.txt", 62491]);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test1.txt", 2713310158], ["input.txt", 17408399184]);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]), 10000, 0);
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
