#!/usr/bin/perl
use warnings;# FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
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
    return bless { ip => 0, p => [@$prog], o => [], i => [$i],
                   b => 0 }, $pkg;
  }

  sub pp {
    my ($self) = @_;
    my $l = main::min($self->{ip} + 3, @{$self->{p}}-1);
    return "ip=$self->{ip}: [",
      (join " ", map { $self->{p}->[$_]//0 } ($self->{ip} .. $l)), "] b=",
      $self->{b};
  }

  sub arity {
    return { 99 => 0, 1 => 3, 2 => 3, 3 => 1, 4 => 1,
             5 => 2, 6 => 2,
             7 => 3, 8 => 3, 9 => 1 }->{$_[0]};
  }

  sub parse_inst {
    my ($self) = @_;
    my $raw_op = $self->{p}->[$self->{ip}];
    $self->{ip}++;
    my %inst = ( param => [], addr => [] );
    $inst{op} = $raw_op % 100;
    my @mode = (map { int($raw_op/$_)%10 } (100,1000,10000));
    for my $i (0..arity($inst{op})-1) {
      if ($mode[$i] == 1) {
        push @{$inst{param}}, $self->{p}->[$self->{ip}];
        push @{$inst{addr}}, -99;
      } elsif ($mode[$i] == 2) {
        push @{$inst{param}}, $self->{p}->[$self->{b}+$self->{p}->[$self->{ip}]];
        push @{$inst{addr}}, $self->{b}+$self->{p}->[$self->{ip}];
      } else {
        push @{$inst{param}}, $self->{p}->[$self->{p}->[$self->{ip}]]//0;
        my $a =$self->{p}->[$self->{ip}];
        push @{$inst{addr}}, $a;
      }
      $self->{ip}++;
    }
    return \%inst;
  }

  sub ppv {
    my ($v) = @_;
    return "[".(join " ", map { $_//0 } @$v)."]";
  }

  sub run {
    my ($self) = @_;
    while (1) {
      #print $self->pp(), "\n" if DEBUG;
      #print "M: $self->{ip} ", ppv($self->{p}), "\n";
      my $inst = $self->parse_inst();
      #printf "op=%d param=%s addr=%s\n",
      #  $inst->{op}, ppv($inst->{param}), ppv($inst->{addr});
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
      } elsif ($op == 9) {
        $self->{b} += $inst->{param}->[0];
        printf "  base += %d == %d\n", $inst->{param}->[0], $self->{b}
          if DEBUG;
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

sub input {
  my ($hull) = @_;
  printf("reading %d from [%d,%d]\n", ($hull->{m}->{hk($hull->{x},$hull->{y})} // 0), $hull->{x},$hull->{y});
  return $hull->{m}->{hk($hull->{x},$hull->{y})} // 0;
}

sub output {
  my ($hull, $val) = @_;
  printf("writing %d to [%d,%d]\n", $val, $hull->{x},$hull->{y});
  $hull->{m}->{hk($hull->{x},$hull->{y})} = $val;
}

sub process_output {
  my ($hull, $ic) = @_;
  my $col = shift @{$ic->{o}};
  my $turn = shift @{$ic->{o}};
  output($hull, $col);
  printf("col: %d turn: %d\n", $col, $turn);
  printf("  d[%d, %d] => ", $hull->{dir}->[X], $hull->{dir}->[Y]);
  $hull->{dir} =
    $turn ? offsetCW(@{$hull->{dir}}) : offsetCCW(@{$hull->{dir}});
  printf(" d[%d, %d]\n", $hull->{dir}->[X], $hull->{dir}->[Y]);
  printf("  p(%d, %d) => ", $hull->{x}, $hull->{y});
  $hull->{x} += $hull->{dir}->[X];
  $hull->{y} += $hull->{dir}->[Y];
  printf(" p(%d, %d)\n", $hull->{x}, $hull->{y});
  printf(" size=%d\n", scalar keys %{$hull->{m}});
  minmax_xy($hull->{bb}, $hull->{x}, $hull->{y});
  return 1;
}

sub run {
  my ($prog, $hull, $input) = @_;
  my $ic = IntCode->new($prog, $input);
  my @out;
  while (!$ic->{done}) {
    my $rc = $ic->run();
    if (@{$ic->{o}} == 2) {
      process_output($hull, $ic);
      #printf(" i: %d\n", input($hull));
      push @{$ic->{i}}, input($hull);
    }
  }
  return $hull;
}

sub calc {
  my ($prog) = @_;
  my $hull = run($prog, { x => 0, y => 0,
                      dir => compassOffset('N'),
                          m => {}, bb => [] }, 0);
  return scalar keys %{$hull->{m}};
}

sub calc2 {
  my ($prog) = @_;
  my $hull = run($prog, { x => 0, y => 0,
                          dir => compassOffset('N'),
                          m => {}, bb => [] }, 1);
  my $s = "";
  for my $y ($hull->{bb}->[MINY] .. $hull->{bb}->[MAXY]) {
    for my $x ($hull->{bb}->[MINX] .. $hull->{bb}->[MAXX]) {
      $s .= $hull->{m}->{hk($x,$y)} ? '#' : '.';
    }
    $s .= "\n";
  }
  return $s;
}

print "Part 1: ", calc($i), "\n";
print "Part 2:\n", calc2($i), "\n";