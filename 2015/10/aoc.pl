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
  $i =~ s/(\d)(\1*)/(1+length $2).$1/ge;
  return $i;
}

my @test_input = split/\n/, <<'EOF';
1 becomes 11 (1 copy of digit 1).
11 becomes 21 (2 copies of digit 1).
21 becomes 1211 (one 2 followed by one 1).
1211 becomes 111221 (one 1, one 2, and two 1s).
111221 becomes 312211 (three 1s, two 2s, and one 1).
EOF
chomp @test_input;

if (TEST) {
  for my $l (@test_input) {
    my ($in, $out) = ($l =~ /(\d+) becomes (\d+)/);
    my $res = calc($in);
    assertEq("Test 1 calc($in)", $out, $res);
  }
}
my $c = $i[0];
for (1..40) {
  $c = calc($c);
}
print "Part 1: ", (length $c), "\n";

$c = $i[0];
for (1..50) {
  $c = calc($c);
  print STDERR "Len $_; ", (length $c), "\r" if DEBUG;
}
print STDERR "\n" if DEBUG;
print "Part 2: ", (length $c), "\n";
