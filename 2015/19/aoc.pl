#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant
  {
   STR => 0,
   COUNT => 1,
   FROM => 0,
   TO => 1,
  };

my @parts;
{
  local $/ = "\n\n";
  @parts = <>;
  chomp @parts;
}

my $rules = parse_rules($parts[0]),
my $molecule = $parts[1];

sub parse_rules {
  my ($lines) = @_;
  my @r;
  for my $l (split /\n/, $lines) {
    if ($l =~ / => /) {
      push @r, [split / => /, $l];
    } else {
      die "invalid rule: $l\n";
    }
  }
  return \@r;
}

sub apply {
  my ($rule, $str) = @_;
  my @r;
  return \@r;
}

sub calc {
  my ($rules, $start) = @_;
  my %r;
  for my $r (@$rules) {
    my $l = length($r->[FROM]);
    while ($start =~ m!$r->[FROM]!g) {
      my $j = (pos $start) - $l;
      my $n = $start;
      substr $n, $j, $l, $r->[TO];
      $r{$n}++;
    }
  }
  return [sort keys %r];
}

my $test_rules = parse_rules(<<'EOF');
H => HO
H => OH
O => HH
EOF

if (TEST) {
  my $res;
  $res = calc($test_rules, 'HOH', 1);
  print "Test 1a: ", ~~@$res, " @$res ==\n".
        "         4 HHHH HOHO HOOH OHOH\n";
  $res = calc($test_rules, 'HOHOHO', 1);
  print "Test 1b: ", ~~@$res, " @$res ==\n".
        "         7 HHHHOHO HOHHHHO HOHOHHH HOHOHOO HOHOOHO HOOHOHO OHOHOHO\n";
}

print "Part 1: ", ~~@{calc($rules, $molecule, 1)}, "\n";

sub calc2 {
  my ($rules, $start, $end) = @_;
  my %reverse = map { ~~reverse($_->[TO]) => ~~reverse($_->[FROM]) } @$rules;
  my $count = 0;
  my $re = join '|', keys %reverse;
  $end = reverse $end;
  while ($end =~ s/($re)/$reverse{$1}/e) {
    print STDERR "$count\r" if DEBUG;
    $count++;
  }
  print STDERR "\n" if DEBUG;
  print STDERR ~~reverse($end), "\n" if DEBUG;
  return $count;
}

$test_rules = parse_rules(<<'EOF');
e => H
e => O
H => HO
H => OH
O => HH
EOF

if (TEST) {
  my $res;
  $res = calc2($test_rules, 'e', 'HOH');
  print "Test 2 HOH: $res == 3\n";
  die "failed\n" unless ($res == 3);
  $res = calc2($test_rules, 'e', 'HOHOHO');
  print "Test 2 HOHOHO: $res == 6\n";
  die "failed\n" unless ($res == 6);
}
print "Part 2: ", calc2($rules, 'e', $molecule), "\n";
