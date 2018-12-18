#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
use constant { A => 0, B => 1 };

my @i = <>;
chomp @i;

my $i = parse_input(\@i);
#dd([$i],[qw/i/]);

sub parse_input {
  my ($lines) = @_;
  my %s;
  for my $l (@$lines) {
    push @{$s{prog}}, [split /,?\s+/, $l];
  }
  return \%s;
}

my %inst_fn =
  (
   hlf => sub {
     my ($r, $a) = @_;
     $r->{$a->[1]} /= 2;
     1;
   },
   tpl => sub {
     my ($r, $a) = @_;
     $r->{$a->[1]} *= 3;
     1;
   },
   inc => sub {
     my ($r, $a) = @_;
     $r->{$a->[1]}++;
     1;
   },
   jmp => sub {
     my ($r, $a) = @_;
     $a->[1]
   },
   jie => sub {
     my ($r, $a) = @_;
     return ($r->{$a->[1]}%2) == 0 ? $a->[2] : 1;
   },
   jio => sub {
     my ($r, $a) = @_;
     return $r->{$a->[1]} == 1 ? $a->[2] : 1;
   },
  );

sub calc {
  my ($g, $initial_a) = @_;
  $initial_a //= 0;
  my %r = ( a => $initial_a, b => 0 );
  my $ip = 0;
  while ($ip < @{$g->{prog}}) {
    my $inst = $g->{prog}->[$ip];
    print "CPU IP=$ip RA=$r{a} RB=$r{b}: @$inst\n" if DEBUG;
    my $j = $inst_fn{$inst->[0]}->(\%r, $inst);
    $ip += $j;
  }
  print "CPU IP=$ip RA=$r{a} RB=$r{b}\n" if DEBUG;
  return \%r;
}

my $test_input;
$test_input = parse_input([split/\n/, <<'EOF']);
inc a
jio a, +2
tpl a
inc a
EOF
#dd([$test_input],[qw/test_input/]);

if (TEST) {
  my $res;
  $res = calc($test_input);
  print "Test 1: $res->{a} == 2\n";
  die "failed\n" unless ($res->{a} == 2);
}

my $part1 = calc($i);
print "Part 1: ", $part1->{b}, "\n";

if (TEST) {
  my $res;
  $res = calc($test_input, 1);
  print "Test 2: $res->{a} == 7\n";
  die "failed\n" unless ($res->{a} == 7);
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc($i, 1)->{b}, "\n";
