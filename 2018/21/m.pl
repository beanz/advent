#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;

my @i = <>;
chomp @i;
my $bound = shift @i;
$bound =~ s/#ip //;

sub mkgoto {
  my ($i, $labels, $line) = @_;
  $line = min($line, scalar @i);
  $labels->{$line}++;
  return "goto L$line;"
}

my @r = (1,0,0,0,0,0);
my $c=1;
my @inst;
my $ip = 0;
my %labels;
while ($ip < @i) {
  my $inst = $i[$ip];
  die unless ($inst =~ /^(.{4})\s+(.*)/);
  my ($op,@o) = ($1, split/\s+/,$2);
  my $c = "/* unknown $op @o */\n";
  if ($op eq 'addi') {
    $c = "R$o[2] = R$o[0] + $o[1];";
  } elsif ($op eq 'addr') {
    $c = "R$o[2] = R$o[0] + R$o[1];";
  } elsif ($op eq 'bani') {
    $c = "R$o[2] = R$o[0] & $o[1];";
  } elsif ($op eq 'bori') {
    $c = "R$o[2] = R$o[0] | $o[1];";
  } elsif ($op eq 'muli') {
    $c = "R$o[2] = R$o[0] * $o[1];";
  } elsif ($op eq 'mulr') {
    $c = "R$o[2] = R$o[0] * R$o[1];";
  } elsif ($op eq 'seti') {
    $c = "R$o[2] = $o[0];";
  } elsif ($op eq 'setr') {
    $c = "R$o[2] = R$o[0];";
  } elsif ($op eq 'eqrr') {
    $c = "R$o[2] = R$o[0] == R$o[1] ? 1 : 0;"
  } elsif ($op eq 'eqri') {
    $c = "R$o[2] = R$o[0] == $o[1] ? 1 : 0;"
  } elsif ($op eq 'gtrr') {
    $c = "R$o[2] = R$o[0] > R$o[1] ? 1 : 0;"
  } elsif ($op eq 'gtir') {
    $c = "R$o[2] = $o[0] > R$o[1] ? 1 : 0;"
  } else {
    die "inst: $inst?\n";
  }
  my $comment = $i[$ip];
  $c =~ s/ R$bound/ $ip/g;
  if ($o[2] == $bound) {
    $comment = "IP! ".$comment;
    if ($c =~ m!= (\d+);!) {
      $c = mkgoto(\@i, \%labels, 1+$1);
    } elsif ($c =~ m!= (\d+) \+ (\d+);!) {
      $c = mkgoto(\@i, \%labels, 1+$1+$2);
    } elsif ($c =~ m!= (\d+) \* (\d+);!) {
      $c = mkgoto(\@i, \%labels, 1+$1*$2);
    } elsif ($c =~ m!= R$bound \+ (\d+);!) {
      $c = mkgoto(\@i, \%labels, 1+$ip+$1);
    } elsif ($c =~ m!= R$bound \* R$bound;!) {
      $c = mkgoto(\@i, \%labels, 1+$ip*$ip);
    } elsif ($bound == $o[0] &&
             $i[$ip-1] =~ /^(?:eq|gt).. \d+ \d+ (\d+)/ && $1 == $o[1]) {
      $c = "if (R$o[1]) { ".mkgoto(\@i, \%labels, 1+1+$ip)." }";
    } elsif ($bound == $o[1] &&
             $i[$ip-1] =~ /^(?:eq|gt).. \d+ \d+ (\d+)/ && $1 == $o[0]) {
      $c = "if (R$o[0]) { ".mkgoto(\@i, \%labels, 1+1+$ip)." }";
    } else {
      $comment = "TOFIX: ".$comment;
    }
  }
  $c = sprintf "%-20s /* %s */", $c, $comment;
  push @inst, $c;
  $ip++;
}

print <<'EOF';
#include <stdio.h>
#include <stdlib.h>

void reg(long r0, long r1, long r2, long r3, long r4, long r5) {
    printf(" [%ld %ld %ld %ld %ld %ld]", r0, r1, r2, r3, r4, r5);
}

int main(int argc, char *argv[])
{
    long R0 = 0, R1 = 0, R2 = 0, R3 = 0, R4 = 0, R5 = 0;
    long c = 0;
    if (argc == 2) {
      R0 = atoi(argv[1]);
    }
EOF
for my $ip (0..$#inst) {
  if ($labels{$ip}) {
    print "  L$ip:\n";
  }
  print "    R$bound = $ip;\n" if ($i[$ip] =~ /R$bound /);
  if (DEBUG) {
    print '    printf("ip=%d", '.$ip."); ";
    print "    reg(R0, R1, R2, R3, R4, R5);";
    print '    printf(" '.$i[$ip].'\n");'."\n";
  }
  print "    $inst[$ip] /* $i[$ip] */\n";
  if ($ip == 28) {
    print '    printf("ip=%d", '.$ip."); ";
    print "    reg(R0, R1, R2, R3, R4, R5);";
    print '    printf(" '.$i[$ip].'\n");'."\n";
  }
}
printf "  L%d:\n", scalar @i;
print <<'EOF';
    printf("R0 = %ld\n", R0);
    return(0);
}
EOF

