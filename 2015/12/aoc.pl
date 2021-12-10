#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = @{read_lines(shift//"input.txt")};

sub calc {
  my ($i) = @_;
  return sum($i =~ m/(-?\d+)/g) // 0;
}

my @test_input = split/\n/, <<'EOF';
[1,2,3] and {"a":2,"b":4} both have a sum of 6.
[[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
{"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
[] and {} both have a sum of 0.
EOF
chomp @test_input;

if (TEST) {
  for my $l (@test_input) {
    my ($a, $b, $expected_sum) =
      ($l =~ /(.*) and (.*) both have a sum of (\d+)/);
    for my $v ($a, $b) {
      my $res = calc($v);
      assertEq("calc($v)", $res, $expected_sum);
    }
  }
}

print "Part 1: ", calc($i[0]), "\n";
use JSON qw/decode_json/;

sub calc2 {
  my ($i) = @_;
  my $o = decode_json $i;
  return calc2_aux($o) // 0;
}

sub calc2_aux {
  my $o = shift;
  my $s;
  if (!ref $o) {
    $s = calc($o)
  } else {
    if (ref $o eq 'ARRAY') {
      $s = sum(map { calc2_aux($_) // 0 } @$o);
    } else {
      if (exists $o->{'red'}) {
        return 0;
      } else {
        $s = 0;
        for my $v (values %$o) {
          if ($v eq "red") {
            return 0;
          }
          $v = calc2_aux($v);
          $s += $v;
        }
      }
    }
  }
  return $s;
}

@test_input = split/\n/, <<'EOF';
[1,2,3] still has a sum of 6.
[1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is ignored.
{"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire structure is ignored.
[1,"red",5] has a sum of 6, because "red" in an array has no effect.
EOF
chomp @test_input;

if (TEST) {
  for my $l (@test_input) {
    $l =~ s/ (?:now|still) / /g;
    my ($v, $expected_sum) =
      ($l =~ /^(.*) has a sum of (\d+)/);
    die "bad test line: $l\n" unless (defined $v);
    my $res = calc2($v);
    assertEq("calc2($v)", $res, $expected_sum);
  }
}
print "Part 2: ", calc2($i[0]), "\n";
