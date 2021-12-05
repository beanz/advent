#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use IntCode;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub runscript {
  my ($prog, $script) = @_;
  print "Running script:\n$script\n" if DEBUG;
  my $ic = IntCode->new($prog, [map { ord $_ } split//,$script]);
  my $s = "";
  while (!$ic->{done}) {
    $ic->run();
    while (my $ch = shift @{$ic->{o}}) {
      if ($ch > 127) {
        return $ch;
      }
      $s .= chr($ch);
    }
  }
  print $s if DEBUG;
  return -1;
}

sub calc {
  my ($prog) = @_;
  # (!C && D) || !A
  my $script = <<'EOF';
NOT C J
AND D J
NOT A T
OR T J
WALK
EOF
  return runscript($prog, $script);
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($prog) = @_;
  # (!A || ( (!B || !C) && H ) ) && D
  my $script = <<'EOF';
NOT B T
NOT C J
OR J T
AND H T
NOT A J
OR T J
AND D J
RUN
EOF
  return runscript($prog, $script);
}

print "Part 2: ", calc2($i), "\n";
