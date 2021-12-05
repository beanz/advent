#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  my %ing;
  for my $l (@$lines) {
    my ($in, $out) = split / => /, $l;
    my ($out_n, $out_name) = split / /, $out;
    $ing{$out_name}->{n} = $out_n;
    $ing{$out_name}->{sur} = 0;
    $ing{$out_name}->{r} = [map { [reverse split/ /, $_] } split /, /, $in];
  }
  return \%ing;
}

sub requirements {
  my ($in, $ch, $n) = @_;
  my $s = 0;
  return if ($ch eq 'ORE');
  $in->{$ch}->{sur}+=0;
  if ($in->{$ch}->{sur} > $n) {
    $in->{$ch}->{sur} -= $n;
    return;
  }
  if ($in->{$ch}->{sur}) {
    $n -= $in->{$ch}->{sur};
    $in->{$ch}->{sur} = 0;
  }
  my $req = ceil($n/$in->{$ch}->{n});
  my $surplus =$in->{$ch}->{n}*$req-$n;
  $in->{$ch}->{sur} += $surplus;
  for my $rec (@{$in->{$ch}->{r}}) {
    my ($i, $m) = @$rec;
    $in->{$i}->{t} += $m*$req;
    requirements($in, $i, $m*$req);
  }
}

sub calc {
  my ($in, $n) = @_;
  requirements($in, 'FUEL', $n);
  return $in->{ORE}->{t};
}
sub part1 {
  my ($in) = @_;
  return calc($in, 1);
}

if (TEST) {
  my @test_cases =
    (
     [ "test1a.txt", 31, 34482758620 ],
     [ "test1b.txt", 165, 6323777403 ],
     [ "test1c.txt", 13312, 82892753 ],
     [ "test1d.txt", 180697, 5586022 ],
     [ "test1e.txt", 2210736, 460664 ],
    );
  for my $tc (@test_cases) {
    my $res = part1(parse_input(read_lines($tc->[0])));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
    $res = part2(parse_input(read_lines($tc->[0])));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[2]);
  }
}

print "Part 1: ", part1($i), "\n";

sub part2 {
  my ($i) = @_;
  my $target = 1000000000000;
  my $upper = 1;
  print "Finding upper bound\n" if DEBUG;
  while (calc(dclone($i), $upper) < $target) {
    $upper *= 2;
    print "  increasing upper bound to $upper\n" if DEBUG;
  }
  my $lower = $upper/2;
  print "Starting bounds $lower .. $upper\n" if DEBUG;
  while (1) {
    my $mid = int(($upper-$lower)/2) + $lower;
    last if ($mid == $lower);
    if (calc(dclone($i), $mid) > $target) {
      $upper = $mid;
    } else {
      $lower = $mid;
    }
    print "  new $lower .. $upper\n" if DEBUG;
  }
  return $lower;
}

$i = parse_input(\@i); # reset input
print "Part 2: ", part2($i), "\n";
