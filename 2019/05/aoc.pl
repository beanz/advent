#!/usr/bin/perl
use warnings;# FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub pp {
  my ($g) = @_;
  my $l = min($g->{ip} + 10, @{$g->{p}}-1);
  return "ip=$g->{ip}: [",
    (join " ", map { $g->{p}->[$_]//-77 } ($g->{ip} .. $l)), "]";
}

sub arity {
  return { 99 => 0, 1 => 3, 2 => 3, 3 => 1, 4 => 1,
           5 => 2, 6 => 2,
           7 => 3, 8 => 3 }->{$_[0]};
}

sub parse_inst {
  my ($g) = @_;
  my $raw_op = $g->{p}->[$g->{ip}];
  $g->{ip}++;
  my %inst = ( param => [], addr => [] );
  $inst{op} = $raw_op % 100;
  my @immediate = (map { int($raw_op/$_)%10 == 1 ? 1 : 0
                       } (100,1000,10000));
  for my $i (0..arity($inst{op})-1) {
    if ($immediate[$i]) {
      push @{$inst{param}}, $g->{p}->[$g->{ip}];
      push @{$inst{addr}}, -99;
    } else {
      push @{$inst{param}}, $g->{p}->[$g->{p}->[$g->{ip}]];
      push @{$inst{addr}}, $g->{p}->[$g->{ip}];
    }
    $g->{ip}++;
  }
  return \%inst;
}

sub calc {
  my ($prog, $input) = @_;
  $input //= 1;
  my $g = { ip => 0, p => $prog };
  my @o;
  while (1) {
    print pp($g), "\n" if DEBUG;
    my $inst = parse_inst($g);
    my $op = $inst->{op};
    if ($op == 1) {
      printf "  %d + %d = %d => %d\n",
        $inst->{param}->[0], $inst->{param}->[1],
        $inst->{param}->[0] + $inst->{param}->[1],
        $inst->{addr}->[2] if DEBUG;
      $g->{p}->[$inst->{addr}->[2]] =
        $inst->{param}->[0] + $inst->{param}->[1];
    } elsif ($op == 2) {
      printf "  %d * %d = %d => %d\n",
        $inst->{param}->[0], $inst->{param}->[1],
        $inst->{param}->[0] * $inst->{param}->[1],
        $inst->{addr}->[2] if DEBUG;
      $g->{p}->[$inst->{addr}->[2]] =
        $inst->{param}->[0] * $inst->{param}->[1];
    } elsif ($op == 3) {
      printf "  %d => %d\n", $input, $inst->{addr}->[0] if DEBUG;
      $g->{p}->[$inst->{addr}->[0]] = $input;
    } elsif ($op == 4) {
      printf "  %d => \@o\n", $inst->{param}->[0] if DEBUG;
      push @o, $inst->{param}->[0];
    } elsif ($op == 5) {
      printf "  jnz %d to %d\n", $inst->{param}->[0], $inst->{param}->[1]
        if DEBUG;
      if ($inst->{param}->[0] != 0) {
        $g->{ip} = $inst->{param}->[1];
      }
    } elsif ($op == 6) {
      printf "  jz %d to %d\n", $inst->{param}->[0], $inst->{param}->[1]
        if DEBUG;
      if ($inst->{param}->[0] == 0) {
        $g->{ip} = $inst->{param}->[1];
      }
    } elsif ($op == 7) {
      printf "  %d < %d => %d\n",
        $inst->{param}->[0], $inst->{param}->[1], $inst->{addr}->[2] if DEBUG;
      $g->{p}->[$inst->{addr}->[2]] =
        $inst->{param}->[0] < $inst->{param}->[1] ? 1 : 0;
    } elsif ($op == 8) {
      printf "  %d == %d => %d\n",
        $inst->{param}->[0], $inst->{param}->[1], $inst->{addr}->[2] if DEBUG;
      $g->{p}->[$inst->{addr}->[2]] =
        $inst->{param}->[0] == $inst->{param}->[1] ? 1 : 0;
    } elsif ($op == 99) {
      return \@o;
    } else {
      die "err\n";
      return;
    }
  }
}

if (TEST) {

  for my $tc ([["1,0,0,3,99"], 1, [1, 1, 3], [0, 0, 3], 4],
              [["2,3,0,3,99"], 2, [3, 2, 3], [3, 0, 3], 4],
              [["1002,4,3,4,33"], 2, [33, 3, 33], [4, -99, 4], 4]) {
    my $g = { ip => 0, p => parse_input($tc->[0]) };
    my $inst = parse_inst($g);
    assertEq("Test parse_inst [@{$tc->[0]}]", $inst->{op}, $tc->[1]);
    assertEq("Test parse_inst [@{$tc->[0]}]",
             "@{$inst->{param}}", "@{$tc->[2]}");
    assertEq("Test parse_inst [@{$tc->[0]}]",
             "@{$inst->{addr}}", "@{$tc->[3]}");
    assertEq("Test parse_inst [@{$tc->[0]}]", $g->{ip}, $tc->[4]);
  }

  my @test_cases =
    (
     [ ["3,0,4,0,99"], 1 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input($tc->[0]));
    assertEq("Test 1 [@{$tc->[0]}]", scalar @$res, 1);
    assertEq("Test 1 [@{$tc->[0]}]", $res->[0], $tc->[1]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1->[-1], "\n";

if (TEST) {
  my @test_cases =
    (
     [ ["3,9,8,9,10,9,4,9,99,-1,8"], 8, 1 ],
     [ ["3,9,8,9,10,9,4,9,99,-1,8"], 4, 0 ],

     [ ["3,9,7,9,10,9,4,9,99,-1,8"], 7, 1 ],
     [ ["3,9,7,9,10,9,4,9,99,-1,8"], 8, 0 ],

     [ ["3,3,1108,-1,8,3,4,3,99"], 8, 1 ],
     [ ["3,3,1108,-1,8,3,4,3,99"], 9, 0 ],

     [ ["3,3,1107,-1,8,3,4,3,99"], 7, 1 ],
     [ ["3,3,1107,-1,8,3,4,3,99"], 9, 0 ],

     [ ["3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"], 2, 1 ],
     [ ["3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"], 0, 0 ],
     [ ["3,3,1105,-1,9,1101,0,0,12,4,12,99,1"], 3, 1 ],
     [ ["3,3,1105,-1,9,1101,0,0,12,4,12,99,1"], 0, 0 ],
     [ ["3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,".
        "1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,".
        "999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"], 5, 999 ],
     [ ["3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,".
        "1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,".
        "999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"], 8, 1000],
     [ ["3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,".
        "1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,".
        "999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"], 9, 1001 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input($tc->[0]), $tc->[1]);
    assertEq("Test 2 [@{$tc->[0]}]", scalar @$res, 1);
    assertEq("Test 2 [@{$tc->[0]}]", $res->[0], $tc->[2]);
  }
}

$i = parse_input(\@i); # reset input
my $part2 = calc($i, 5);
print "Part 2: ", $part2->[-1], "\n";
