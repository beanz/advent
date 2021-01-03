#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $input;
{
  local $/;
  $input = <>;
}

sub parse_output_chunk {
  my ($chunk) = @_;
  my ($b, $o, $a) = ($chunk =~ m!Before: \[(.*?)\]\n(.*?)\nAfter: +\[(.*?)\]!);
  die "invalid output chunk:\n$chunk\n" unless (defined $b);
  my @b = split /, /, $b;
  die "invalid output chunk: before=$b\n" unless (@b == 4);
  my @o = split / /, $o;
  die "invalid output chunk: output=$o\n" unless (@o == 4);
  my @a = split /, /, $a;
  die "invalid output chunk: output=$o\n" unless (@a == 4);
  return [\@b, \@o, \@a];
}
my ($output, $program) = split /\n\n\n\n/, $input;
my @output;
for my $chunk (split /\n\n/, $output) {
  push @output, parse_output_chunk($chunk);
}

my @program;
foreach my $inst (split /\n/, $program) {
  my @o = split/ /, $inst;
  my $n = shift @o;
  die "invalid instruction, $inst: bad op\n" if ($n < 0 || $n > 15);
  die "invalid instruction, $inst: bad op\n" unless (@o == 3);
  push @program, [$n, \@o];
}

print "Output parsed ", ~~@output, " output chunks\n";
print "Program parsed ", ~~@program, " instructions\n";

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
     $r->[$C] = $r->[$A] & $r->[$B];
   },
   'bani' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] & $B;
   },
   'borr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] | $r->[$B];
   },
   'bori' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A] | $B;
   },
   'setr' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $r->[$A];
   },
   'seti' => sub {
     my ($r, $A, $B, $C) = @_;
     $r->[$C] = $A;
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

sub matches {
  my ($b, $o, $a) = @_;
  my @m = ();
  my @o = @$o;
  my $n = shift @o;
  for my $op (keys %ops) {
    my @r = @$b;
    $ops{$op}->(\@r, @o);
    my $exp = join ', ', map { $a->[$_] } 0..3;
    my $res = join ', ', map { $r[$_] } 0..3;
    if ($exp eq $res) {
      #print STDERR "matched $op\n" if DEBUG;
      push @m, $op;
    }
  }
  return \@m;
}

sub calc {
  my ($i) = @_;
  my $c = 0;
  for my $s (@$i) {
    my @m = @{matches(@$s)};
    $c++ if (@m >= 3);
  }
  return $c;
}

my @test_input;
push @test_input, parse_output_chunk(<<'EOF');
Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]
EOF

if (TEST) {
  my $res = calc(\@test_input);
  print "Test 1: $res == 1\n";
  die "failed\n" unless ($res eq 1);
}

my $part1 = calc(\@output);
print "Part 1: $part1\n";
die unless ($part1 == 544);

sub consistent {
  my ($samples, $code, $op) = @_;
  foreach my $s (@$samples) {
    my ($b, $o, $a) = @$s;
    my @o = @$o;
    my $n = shift @o;
    next unless ($n eq $code);
    my @r = @$b;
    $ops{$op}->(\@r, @o);
    my $exp = join ', ', map { $a->[$_] } 0..3;
    my $res = join ', ', map { $r[$_] } 0..3;
    return unless ($exp eq $res);
  }
  return 1;
}

sub calc2 {
  my ($samples) = @_;
  my %op2code;
  foreach my $op (keys %ops) {
    foreach my $i (0..15) {
      if (consistent($samples, $i, $op)) {
        $op2code{$op}->{$i}++;
      }
    }
  }
  if (DEBUG) {
    printf STDERR "%s: %s\n", $_,
      join ' ', sort { $a <=> $b } keys %{$op2code{$_}}
        foreach (sort keys %op2code);
  }
  my %solution; # opcode to opname
 LOOP:
  while (keys %solution != 16) {
    for my $op (keys %op2code) {
      my @possible_codes = keys %{$op2code{$op}};
      if (@possible_codes == 1) {
        my $code = $possible_codes[0];
        print STDERR "Found: $op => $code\n" if DEBUG;
        $solution{$code} = $op;
        delete $op2code{$op};
        delete $op2code{$_}->{$code} foreach (keys %op2code);
        next LOOP;
      }
    }
    # Thought I might need to do the equivalent check in code2os but
    # it wasn't necessary for my input
    printf STDERR "%s: %s\n", $_,
      join ' ', sort { $a <=> $b } keys %{$op2code{$_}}
        foreach (sort keys %op2code);
    die "Failed to deduce codes\n";
  }
  return \%solution;
}

my $part1b = calc2(\@output);
my $ops = join ' ', map { $part1b->{$_} } sort { $a <=> $b } keys %{$part1b};
print "Part 1b:\n $ops\n";
my @correct = qw/addi eqrr borr gtri addr seti muli bani
                 banr gtrr setr gtir bori eqri eqir mulr/;
my @wrong;
for my $i (0..$#correct) {
  push @wrong,
    sprintf "%d should be %s not %s\n", $i, $correct[$i], $part1b->{$i}
    unless ($correct[$i] eq $part1b->{$i});
  $part1b->{$i} = $correct[$i];
}
warn @wrong if (@wrong);

my @r = (0,0,0,0);
for my $i (@program) {
  my ($opcode, $operands) = @$i;
  my $op = $part1b->{$opcode};
  $ops{$op}->(\@r, @$operands);
  # print STDERR "R: @r\n";
}
print "Part 2: $r[0]\n";

