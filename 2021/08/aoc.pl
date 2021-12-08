#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub l2i {
  2**((ord $_[0]) - (ord 'a'))
}

sub s2i {
  my $r = 0;
  $r |= l2i($_) for (split//, $_[0]);
  $r
}

sub i2s {
  my $r = "";
  for my $i (0..6) {
    $r .= chr((ord'a')+$i) if (($_[0]&(2**$i))!=0);
  }
  return $r;
}

my @digits = qw/abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg/;
my %digitm;
for my $j (0..@digits-1) {
  $digitm{s2i($digits[$j])} = $j;
}

sub read_stuff {
  my ($file) = @_;
  my @i;
  my $lines = read_lines($file);
  for my $i (0..@$lines-1) {
    my $l = $lines->[$i];
    my @s = split / \| /, $l;
    my @p = split/ /, $s[0];
    my @o = split/ /,$s[1];
    my $r = { line => $l, lineno => $i, };
    push @i, $r;
    my @pi = map { s2i($_) } @p;
    $r->{oi} = [map { s2i($_) } @o];
    my %oc;
    for my $i (0..@o-1) {
      $oc{length($o[$i])}++;
    }
    $r->{oc} = \%oc;
    my %pm = ();
    for my $i (0..@p-1) {
      push @{$pm{length($p[$i])}}, $pi[$i];
    }
    $r->{pm} = \%pm;
  }
  return \@i;
}

sub calc {
  my ($in) = @_;
  my $c = 0;
  return sum(map { my $r = $_; sum(map { $r->{oc}->{$_}//0 } 2,3,4,7) } @$in);
}

sub pretty_perm {
  my ($p) = @_;
  return join(", ", sort map { i2s($_).">".i2s($p->{$_}) } keys %$p);
}

sub perm_for {
  my ($lm) = @_;
  my %m;
  $m{cf} = $lm->{2}->[0]; # 1
  $m{acf} = $lm->{3}->[0]; # 7
  $m{bcdf} = $lm->{4}->[0]; # 4
  $m{abcdefg} = $lm->{7}->[0]; # 8
  $m{a} = $m{acf} ^ $m{cf};
  $m{abfg} = ($lm->{6}->[0]^$lm->{6}->[1]^$lm->{6}->[2]);
  $m{cde} = $m{abcdefg}^$m{abfg};
  $m{c} = $m{cde}&$m{cf};
  $m{f} = $m{c}^$m{cf};
  $m{bg} = $m{abfg}^($m{f}|$m{a});
  $m{b} = $m{bcdf}&$m{bg};
  $m{g} = $m{b}^$m{bg};
  $m{de} = $m{cde}^$m{c};
  $m{d} = $m{bcdf}&$m{de};
  $m{e} = $m{d}^$m{de};

  my %p;
  for my $k (sort keys %m) {
    printf("%7s: %07b\n", $k, $m{$k}) if DEBUG;
    $p{$m{$k}} = s2i($k)  if (length $k == 1);
  }
  return \%p;
}

sub apply_perm {
  my ($p, $v) = @_;
  my $r = 0;
  for my $i (0..6) {
    my $bit = 2**$i;
    $r |= $p->{$bit} if (($v&$bit)!=0);
  }
  return $r;
}

sub calc2 {
  my ($in) = @_;
  my $c = 0;
  for my $r (@$in) {
    my $p = perm_for($r->{pm});
    print "$r->{line}: ", pretty_perm($p), "\n" if DEBUG;
    my $n = 0;
    for my $d (@{$r->{oi}}) {
      my $nd = apply_perm($p, $d);
      print $nd, " ", i2s($nd), "\n" if DEBUG;
      $n = $n * 10 + $digitm{$nd} // die "Invalid $d\n";
    }
    $c += $n;
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test0.txt", 2 ],
     [ "test1.txt", 26 ],
     [ "test2.txt", 0 ],
     [ "input.txt", 504 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test0.txt", 8394 ],
     [ "test1.txt", 61229 ],
     [ "test2.txt", 5353 ],
     [ "input.txt", 1073431 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
