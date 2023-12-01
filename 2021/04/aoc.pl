#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_bingo;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_bingo {
  my $f = shift;
  my $in = read_chunks($f);
  my @calls = split /,/, shift @$in;
  my @b;
  my %m;
  my @s;
  for my $i (0..(@$in-1)) {
    my $b = [map { [split] } split /\n/, $in->[$i]];
    push @b, $b;
    for my $rn (0..4) {
      my $r = $b->[$rn];
      for my $cn (0..4) {
        my $n = $r->[$cn];
        $s[$i]+=$n;
        push @{$m{$n}}, { board =>  $i, row => $rn, col => $cn };
      }
    }
  }
  return { calls => \@calls, boards => \@b, m => \%m, scores => \@s, wins => [], left => scalar @b };
}

sub calc {
  my ($in) = @_;
  my $p1 = -1;
  my $go = 0;
  for my $call (@{$in->{calls}}) {
    $go++;
    for my $rec (@{$in->{m}->{$call}}) {
      next if (defined $in->{wins}->[$rec->{board}]); # already won so ignore
      $in->{scores}->[$rec->{board}]-=$call;
      my $cr;
      my $cc;
      my $b = $in->{boards}->[$rec->{board}];
      $b->[$rec->{row}]->[$rec->{col}] = undef;
      for my $i (0..4) {
        $cr++ if (!defined $b->[$i]->[$rec->{col}]);
        $cc++ if (!defined $b->[$rec->{row}]->[$i]);
      }
      if ($cr == 5 || $cc == 5) {
        $in->{wins}->[$rec->{board}]++;
        my $s = $call * $in->{scores}->[$rec->{board}];
        $p1 = $s if ($p1 == -1);
        $in->{left}--;
        return [$p1, $s] unless ($in->{left});
      }
    }
  }
  return [$p1, -2];
}

testCalc() if (TEST);

my ($p1, $p2) = @{calc($i)};
print "Part 1: $p1\n";
print "Part 2: $p2\n";

sub testCalc {
  my @test_cases =
    (
     [ "test1.txt", 4512, 1924 ],
     [ "input.txt", 63552, 9020 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 2 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
