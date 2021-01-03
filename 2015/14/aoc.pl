#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $endTime = 2503;
$endTime = 1000 if (@ARGV && $ARGV[0] eq 'test1.txt');

my @i = <>;
chomp @i;

sub calc_aux {
  my ($i, $end) = @_;
  my %r;
  for my $l (@$i) {
    next unless ($l =~
                 m!(.*) can fly (\d+) km/s for (\d+) seconds, .* for (\d+)!);
    $r{$1} = { v => $2, vs => $3, rs => $4, d => 0, move => $3, score => 0 };
  }
  my $t = 0;
  while ($t < $end) {
    for my $v (values %r) {
      if (exists $v->{move}) {
        if ($v->{move} > 0) {
          $v->{d} += $v->{v};
          $v->{move}--;
          if ($v->{move} == 0) {
            delete $v->{move};
            $v->{rest} = $v->{rs};
          }
        }
      } else {
        if ($v->{rest} > 0) {
          $v->{rest}--;
          if ($v->{rest} == 0) {
            delete $v->{rest};
            $v->{move} = $v->{vs};
          }
        }
      }
    }
    my $d = max(map { $_->{d} } values %r);
    for my $n (keys %r) {
      if ($d == $r{$n}->{d}) {
        $r{$n}->{score}++;
      }
    }
    $t++;
  }
  return \%r;
}

sub calc {
  my $r = calc_aux(@_);
  return max(map { $_->{d} } values %$r);
}

my @test_input = split/\n/, <<'EOF';
Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
EOF
chomp @test_input;

if (TEST) {
  assertEq("Test 1", calc(\@test_input, 1000), 1120);
}
print "Part 1: ", calc(\@i, $endTime), "\n";

sub calc2 {
  my $r = calc_aux(@_);
  if (DEBUG) {
    for my $n (keys %$r) {
      print "$n: ", $r->{$n}->{score}, "\n";
    }
  }
  return max(map { $_->{score} } values %$r);
}

if (TEST) {
  assertEq("Test 2 (1)", calc2(\@test_input, 1), 1);
  assertEq("Test 2 (1000)", calc2(\@test_input, 1000), 689);
}

print "Part 2: ", calc2(\@i, $endTime), "\n";
