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
  my %m = ( t => $in->[0], m => {}, r => {} );
  for my $i (2..(@$in-1)) {
    my ($in, $out) = split / -> /, $in->[$i];
    $m{m}->{$in} = $out;
    push @{$m{r}->{$out}}, $in;
  }
  return \%m;
}

sub most_least {
  my ($t) = @_;
  my %c;
  $c{$_}++ for (split //, $t);
  my @n = sort { $c{$a} <=> $c{$b} } keys %c;
  return ($c{$n[-1]}, $c{$n[0]});
}

sub calc {
  my ($in, $steps) = @_;
  $steps //= 10;
  my $t = $in->{t};
  my ($m, $l) = (0,0);
  for my $step (1..$steps) {
    my $n = "";
    for my $i (0..length($t)-2) {
      my $k = substr $t, $i, 2;
      my ($a, $b) = split //, $k;
      $n .= $a.$in->{m}->{$k};
    }
    $n .= substr $t, length($t)-1;
    $t = $n;
    ($m, $l) = most_least($t);
  }
  return $m-$l;
}

sub pp {
  join " ", map {
    $_."=>".$_[0]->{$_}
  } sort {
    $_[0]->{$a} <=> $_[0]->{$b} || $a cmp $b
  } keys %{$_[0]};
}

sub pair_counts {
  my ($t) = @_;
  my %c;
  for my $i (0..length($t)-2) {
    my $k = substr $t, $i, 2;
    $c{$k}++;
  }
  return \%c;
}

sub most_least2 {
  my ($pc, $last) = @_;
  $last //= "B";
  my %c = ( $last => 1 ); # last char
  for my $p (keys %{$pc}) {
    my ($a, $b) = split//, $p;
    $c{$a} += $pc->{$p};
  }
  my @n = sort { $c{$a} <=> $c{$b} } keys %c;
  return ($c{$n[-1]}, $c{$n[0]});
}

sub calc2 {
  my ($in, $steps) = @_;
  $steps //= 10;
  my $last = substr $in->{t}, -1, 1;
  my %c = %{ pair_counts($in->{t}) };
  my ($m, $l) = (0, 0);
  for my $step (1..$steps) {
    my %n;
    for my $ab (keys %c) {
      my ($a, $c) = split//, $ab;
      my $b = $in->{m}->{$ab};
      $n{"$a$b"}+= $c{$ab};
      $n{"$b$c"}+=$c{$ab};
    }
    %c = %n;
    ($m, $l) = most_least2(\%c, $last);
  }
  return $m - $l;
}

testPart1() if (TEST);

print "Part 1: ", calc($i, 10), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2, 40), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 1, 1 ],
     [ "test1.txt", 2, 5 ],
     [ "test1.txt", 3, 7 ],
     [ "test1.txt", 4, 18 ],
     [ "test1.txt", 5, 33 ],
     [ "test1.txt", 10, 1588 ],
     #[ "input.txt", 2891 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 1 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "NNCB", "test1.txt", 1 ],
     [ "NCNBCHB", "test1.txt", 5 ],
     [ "NBCCNBBBCBHCB", "test1.txt", 7 ],
    );
  for my $tc (@test_cases) {
    my $in = $reader->($tc->[1]);
    $in->{t} = $tc->[0];
    my $res = calc2($in, 1);
    assertEq("Test 1 [$tc->[0] with $tc->[1]]", $res, $tc->[2]);
  }

  @test_cases =
    (
     [ "test1.txt", 1, 1 ],
     [ "test1.txt", 2, 5 ],
     [ "test1.txt", 3, 7 ],
     [ "test1.txt", 4, 18 ],
     [ "test1.txt", 5, 33 ],
     [ "test1.txt", 10, 1588 ],
     #[ "input.txt", 2891 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]), $tc->[1]);
    assertEq("Test 1 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}

__END__
2 - 1 = 1
6 - 1 = 5
11 - 4 = 7
23 - 5 = 18
46 - 13 = 33
98 - 16 = 82
199 - 39 = 160
417 - 51 = 366
845 - 118 = 727
1749 - 161 = 1588
3539 - 357 = 3182
7256 - 506 = 6750
14656 - 1083 = 13573
29846 - 1585 = 28261
60184 - 3292 = 56892
121971 - 4951 = 117020
245585 - 10025 = 235560
495993 - 15430 = 480563
997382 - 30577 = 966805
2009315 - 47997 = 1961318
4036129 - 93390 = 3942739
8116274 - 149065 = 7967209
16288747 - 285575 = 16003172
32710959 - 462342 = 32248617
