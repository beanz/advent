#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

$|=1;
my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

{
  package IntCode;

  use constant { DEBUG => 0 };

  sub new {
    my ($pkg, $prog, $i) = @_;
    return bless { ip => 0, p => [@$prog], o => [], i => $i,
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
        push @{$inst{param}}, $self->{p}->[$self->{b}+$self->{p}->[$self->{ip}]]//0;
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
      # printf "op=%d param=%s addr=%s\n",
      #   $inst->{op}, ppv($inst->{param}), ppv($inst->{addr});
      my $op = $inst->{op};
      if ($op == 1) {
        printf "  add %d + %d = %d => %d\n",
          $inst->{param}->[0], $inst->{param}->[1],
          $inst->{param}->[0] + $inst->{param}->[1],
          $inst->{addr}->[2] if DEBUG;
        $self->{p}->[$inst->{addr}->[2]] =
          $inst->{param}->[0] + $inst->{param}->[1];
      } elsif ($op == 2) {
        printf "  mul %d * %d = %d => %d\n",
          $inst->{param}->[0], $inst->{param}->[1],
          $inst->{param}->[0] * $inst->{param}->[1],
          $inst->{addr}->[2] if DEBUG;
        $self->{p}->[$inst->{addr}->[2]] =
          $inst->{param}->[0] * $inst->{param}->[1];
      } elsif ($op == 3) {
        my $v = shift @{$self->{i}};
        printf "  read %d => %d\n", $v, $inst->{addr}->[0] if DEBUG;
        $self->{p}->[$inst->{addr}->[0]] = $v;
      } elsif ($op == 4) {
        printf "  write %d => output\n", $inst->{param}->[0] if DEBUG;
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
        printf "  lt %d < %d => %d\n",
          $inst->{param}->[0], $inst->{param}->[1], $inst->{addr}->[2]
          if DEBUG;
        $self->{p}->[$inst->{addr}->[2]] =
          $inst->{param}->[0] < $inst->{param}->[1] ? 1 : 0;
      } elsif ($op == 8) {
        printf "  eq %d == %d => %d\n",
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

sub draw {
  my ($D) = @_;
  my $s = "";
  my $bot = '^';
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      $s .= $D->{m}->{hk($x,$y)} ? '#' : '.';
    }
    $s .= "\n";
  }
  return $s;
}

sub in_beam {
  my ($prog, $x, $y) = @_;
  my $ic = IntCode->new($prog, [$x, $y]);
  while (!$ic->{done}) {
    $ic->run();
    if (@{$ic->{o}} == 1) {
      return $ic->{o}->[0] == 1;
    }
  }
}

sub part1 {
  my ($prog, $max) = @_;
  my $D =
    {
     bb => [],
     m => {},
    };
  minmax_xy($D->{bb}, 0,0);
  minmax_xy($D->{bb}, $max, $max,2);
  my $count = 0;
  my $first;
  my $last;
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    undef $first;
    undef $last;
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      if (in_beam($prog, $x, $y)) {
        if (!defined $first) {
          $first = $x;
        }
        $last = $x;
        $D->{m}->{hk($x,$y)} = '#';
        $count++;
      }
    }
  }
  print draw($D) if DEBUG;
  return $count, $first, $last;
}

sub find_ratios {
  my ($prog, $y) = @_;
  my $first = 49;
  while (!in_beam($prog, $first, $y)) {
    $first++;
  }
  my $last = $first;
  while (in_beam($prog, $last, $y)) {
    $last++;
  }
  return ($first, $last);
}

my ($count, $first, $last) = part1($i, 49);
print "Part 1: $count\n";
if (!defined $first) {
  ($first, $last) = find_ratios($i, 49);
}

my $r1 = $first / 49;
my $r2 = $last / 49;

sub square_fits {
  my ($prog, $x, $y) = @_;

  if (in_beam($prog, $x, $y) &&
      in_beam($prog, $x+99, $y) &&
      in_beam($prog, $x, $y+99) &&
      in_beam($prog, $x+99, $y+99)) {
    return 1;
  }
  return undef;
}

sub square_fits_y {
  my ($prog, $y, $r1, $r2) = @_;
  my $min = int($y*$r1);
  my $max = int($y*$r2);
  for my $x ($min .. $max) {
    return $x if (square_fits($i, $x, $y));
  }
  return;
}

$i = parse_input(\@i);
my $upper = 64;
while (!square_fits_y($i, $upper, $r1, $r2)) {
  $upper *= 2;
  print "... $upper\n" if DEBUG;
}

my $lower = $upper / 2;
print "$lower .. $upper\n" if DEBUG;

while (1) {
  my $mid = int(($upper-$lower)/2) + $lower;
  last if ($mid == $lower);
  if (square_fits_y($i, $mid, $r1, $r2)) {
    $upper = $mid;
  } else {
    $lower = $mid;
  }
  print "  new $lower .. $upper\n" if DEBUG;
}
print "Close lower y: $lower\n" if DEBUG;

for my $y ($lower..$lower+5) {
  my $x = square_fits_y($i, $y, $r1, $r2);
  if ($x) {
    print "Part 2: ", $x*10000 + $y, "\n";
    last;
  }
}

