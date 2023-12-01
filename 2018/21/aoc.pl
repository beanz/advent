#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

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
   'banr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = (0+$r->[$A]) & (0+$r->[$B]);
   },
   'bani' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = (0+$r->[$A]) & (0+$B);
   },
   'borr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = (0+$r->[$A]) | (0+$r->[$B]);
   },
   'bori' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = (0+$r->[$A]) | (0+$B);
   },
   'setr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = 0+$r->[$A];
   },
   'seti' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = 0+$A;
   },

   'gtir' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $A > $r->[$B] ? 1 : 0;
   },
   'gtri' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] > $B ? 1 : 0;
   },
   'gtrr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] > $r->[$B] ? 1 : 0;
   },

   'eqir' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $A == $r->[$B] ? 1 : 0;
   },
   'eqri' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] == $B ? 1 : 0;
   },
   'eqrr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] == $r->[$B] ? 1 : 0;
   },
  );

my $i = parse_input(\@i);
#dd([$i],[qw/i/]);

sub parse_input {
  my ($lines) = @_;
  return $lines;
}

sub run {
  my ($i, $r, $iterations) = @_;
  my @r = (0, 0, 0, 0, 0, 0);
  my $ip = 0;
  my $bound = shift @$i;
  $bound =~ s/#ip //;
  my $vc = visit_checker();
  my $previous;
  while ($ip < @$i) {
    my $inst = $i->[$ip];
    die "Invalid instruction: $inst\n" unless ($inst =~ /^(.{4})\s+(.*)/);
    my ($op,@operands) = ($1, split/\s+/,$2);
    $r[$bound] = $ip;
    if ($ip == 28) {
      unless (defined $previous) {
        print "Part 1: ", $r[5], "\n";
      }
      if ($vc->($r[5])) {
        print "Part 2: ", $previous, "\n";
        exit;
      }
      $previous = $r[5];
    }
    print STDERR "ip=$ip [@r] $op @operands\n" if ($ip == 28 && DEBUG);
    $ops{$op}->(\@r, @operands);
    $ip = $r[$bound];
    $ip++;
  }
}

run($i);
