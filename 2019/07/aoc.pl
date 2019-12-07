#!/usr/bin/perl
use warnings;# FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/permutations/;

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

{
  package IntCode;

  use constant { DEBUG => main::DEBUG };

  sub new {
    my ($pkg, $prog, $i) = @_;
    return bless { ip => 0, p => [@$prog], o => [], i => [@{$i||[]}] }, $pkg;
  }

  sub pp {
    my ($self) = @_;
    my $l = main::min($self->{ip} + 10, @{$self->{p}}-1);
    return "ip=$self->{ip}: [",
      (join " ", map { $self->{p}->[$_]//-77 } ($self->{ip} .. $l)), "]";
  }

  sub arity {
    return { 99 => 0, 1 => 3, 2 => 3, 3 => 1, 4 => 1,
             5 => 2, 6 => 2,
             7 => 3, 8 => 3 }->{$_[0]};
  }

  sub parse_inst {
    my ($self) = @_;
    my $raw_op = $self->{p}->[$self->{ip}];
    $self->{ip}++;
    my %inst = ( param => [], addr => [] );
    $inst{op} = $raw_op % 100;
    my @immediate = (map { int($raw_op/$_)%10 == 1 ? 1 : 0
                         } (100,1000,10000));
    for my $i (0..arity($inst{op})-1) {
      if ($immediate[$i]) {
        push @{$inst{param}}, $self->{p}->[$self->{ip}];
        push @{$inst{addr}}, -99;
      } else {
        push @{$inst{param}}, $self->{p}->[$self->{p}->[$self->{ip}]];
        push @{$inst{addr}}, $self->{p}->[$self->{ip}];
      }
      $self->{ip}++;
    }
    return \%inst;
  }

  sub run {
    my ($self) = @_;
    while (1) {
      print $self->pp(), "\n" if DEBUG;
      my $inst = $self->parse_inst();
      my $op = $inst->{op};
      if ($op == 1) {
        printf "  %d + %d = %d => %d\n",
          $inst->{param}->[0], $inst->{param}->[1],
          $inst->{param}->[0] + $inst->{param}->[1],
          $inst->{addr}->[2] if DEBUG;
        $self->{p}->[$inst->{addr}->[2]] =
          $inst->{param}->[0] + $inst->{param}->[1];
      } elsif ($op == 2) {
        printf "  %d * %d = %d => %d\n",
          $inst->{param}->[0], $inst->{param}->[1],
          $inst->{param}->[0] * $inst->{param}->[1],
          $inst->{addr}->[2] if DEBUG;
        $self->{p}->[$inst->{addr}->[2]] =
          $inst->{param}->[0] * $inst->{param}->[1];
      } elsif ($op == 3) {
        my $v = shift @{$self->{i}} // 0;
        printf "  %d => %d\n", $v, $inst->{addr}->[0] if DEBUG;
        $self->{p}->[$inst->{addr}->[0]] = $v;
      } elsif ($op == 4) {
        printf "  %d => output\n", $inst->{param}->[0] if DEBUG;
        push @{$self->{o}}, $inst->{param}->[0];
        return 0;
      } elsif ($op == 5) {
        printf "  jnz %d to %d\n", $inst->{param}->[0], $inst->{param}->[1]
          if DEBUG;
        if ($inst->{param}->[0] != 0) {
          $self->{ip} = $inst->{param}->[1];
        }
      } elsif ($op == 6) {
        printf "  jz %d to %d\n", $inst->{param}->[0], $inst->{param}->[1]
          if DEBUG;
        if ($inst->{param}->[0] == 0) {
          $self->{ip} = $inst->{param}->[1];
        }
      } elsif ($op == 7) {
        printf "  %d < %d => %d\n",
          $inst->{param}->[0], $inst->{param}->[1], $inst->{addr}->[2]
          if DEBUG;
        $self->{p}->[$inst->{addr}->[2]] =
          $inst->{param}->[0] < $inst->{param}->[1] ? 1 : 0;
      } elsif ($op == 8) {
        printf "  %d == %d => %d\n",
          $inst->{param}->[0], $inst->{param}->[1], $inst->{addr}->[2]
          if DEBUG;
        $self->{p}->[$inst->{addr}->[2]] =
          $inst->{param}->[0] == $inst->{param}->[1] ? 1 : 0;
      } elsif ($op == 99) {
        $self->{done}=1;
        return 1;
      } else {
        die "err\n";
        return -1;
      }
    }
  }
}

sub try_phase {
  my ($prog, $phase) = @_;
  print "Testing phase: @$phase\n" if DEBUG;
  my @a = map { IntCode->new($prog,[$phase->[$_]]) } 0..4;
  my $done = 0;
  my $last;
  my $out;
  while ($done != 5) {
    for my $u (0..4) {
      if ($a[$u]->{done}) {
        print "unit $u halted\n" if DEBUG;
        $done++;
      } else {
        push @{$a[$u]->{i}}, $out if (defined $out);
        my $rc = $a[$u]->run();
        $out = shift @{$a[$u]->{o}};
        $last = $out if (defined $out);
        print "ran unit $u and received ", ($out//'nil')," ($rc)\n" if DEBUG;
        $done++ if ($rc);
      }
    }
  }
  return $last;
}

sub calc {
  my ($prog) = @_;
  my $iter = permutations([0..4]);
  my $max;
  while (my $p = $iter->next) {
    my $thrust = try_phase($prog, $p);
    $max = $thrust if (!defined $max || $max < $thrust);
  }
  return $max;
}

sub calc2 {
  my ($prog) = @_;
  my $iter = permutations([5..9]);
  my $max;
  while (my $p = $iter->next) {
    my $thrust = try_phase($prog, $p);
    $max = $thrust if (!defined $max || $max < $thrust);
  }
  return $max;
}

if (TEST) {

  for my $tc ([["3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"],
               [4,3,2,1,0], 43210 ],
              [["3,23,3,24,1002,24,10,24,1002,23,-1,23,".
                "101,5,23,23,1,24,23,23,4,23,99,0,0"], [0,1,2,3,4], 54321 ],
              [["3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,".
                "1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"],
               [1,0,4,3,2], 65210 ]) {
    my $ti = parse_input($tc->[0]);
    my $o = try_phase($ti, $tc->[1]);
    assertEq("Test try_phase [@{$tc->[0]}]", $o, $tc->[2]);
    assertEq("Test calc [@{$tc->[0]}]", calc($ti), $tc->[2]);
  }
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

if (TEST) {
  for my $tc ([["3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,".
                "27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"],
               [9,8,7,6,5], 139629729 ],
              [["3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,".
                "55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,".
                "1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,".
                "0,0,0,0,10"], [9,7,8,5,6], 18216]) {
    my $ti = parse_input($tc->[0]);
    my $o = try_phase($ti, $tc->[1]);
    assertEq("Test try_phase [@{$tc->[0]}]", $o, $tc->[2]);
    assertEq("Test calc [@{$tc->[0]}]", calc2($ti), $tc->[2]);
  }
}

my $part2 = calc2($i);
print "Part 2: ", $part2, "\n";
