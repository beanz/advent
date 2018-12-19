#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;

my @i = <>;
chomp @i;

my @s = @i;

my %ops =
  (
   'addr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] + $r->[$B];
   },
   'addi' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] + $B;
   },
   'mulr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] * $r->[$B];
   },
   'muli' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] * $B;
   },
   'setr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A];
   },
   'seti' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $A;
   },

   'gtrr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] > $r->[$B] ? 1 : 0;
   },

   'eqrr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] == $r->[$B] ? 1 : 0;
   },
  );

sub run {
  my ($i, $r, $iterations) = @_;
  my $ip = 0;
  my $bound = shift @$i;
  $bound =~ s/#ip //;
  my $c=1;
  while ($ip < @$i && $c < $iterations) {
    my $inst = $i->[$ip];
    die "Invalid instruction: $inst\n" unless ($inst =~ /^(.{4})\s+(.*)/);
    my ($op,@operands) = ($1, split/\s+/,$2);
    $r->[$bound] = $ip;
    print STDERR "ip=$ip [@$r] $op @operands" if DEBUG;
    $ops{$op}->($r, @operands);
    $ip = $r->[$bound];
    print STDERR " [@$r]\n" if DEBUG;
    $ip++;
    $c++;
  }
  return $r;
}

if (TEST) {
  my @test_input;
  push @test_input, split /\n/, <<'EOF';
#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5
EOF
  my @r = (0,0,0,0,0,0);
  run(\@test_input, \@r, 10000);
  print "Test 1: $r[0] == 6\n";
  die "failed\n" unless ($r[0] == 6);
}

my @r = (0,0,0,0,0,0);
run(\@i, \@r, 100000000);
print "Part 1: $r[0]\n";

@i = @s;
@r = (1,0,0,0,0,0);
run(\@i, \@r, 1000);
my $sum = sum(map { ($r[4]%$_) == 0 ? $_ : 0 } 1..$r[4]);
print "Part 2: $sum\n";
