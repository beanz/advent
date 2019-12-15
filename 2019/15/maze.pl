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

  use constant { DEBUG => main::DEBUG };

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
        my $v = $self->{i}->();
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
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      if ($x == $D->{pos}->[X] && $y == $D->{pos}->[Y]) {
        $s .= 'D';
      } elsif ($D->{oxy} && $x == $D->{oxy}->[X] && $y == $D->{oxy}->[Y]) {
        $s .= 'O';
      } elsif ($x == 0 && $y == 0) {
        $s .= 'S';
      } else {
        $s .= $D->{wall}->{hk($x,$y)} ? '#' : '.';
      }
    }
    $s .= "\n";
  }
  return $s;
}

sub dirstr {
  my $dir = shift;
  return ['', 'N', 'S', 'W', 'E']->[$dir];
}

sub dirnum {
  my $dirstr = shift;
  return { N => 1, S => 2, W => 3, E => 4 }->{$dirstr};
}

sub posstr {
  my $pos = shift;
  return "[".$pos->[X].','.$pos->[Y]."]";
}

sub find_maze {
  my ($prog) = @_;
  my $D =
    {
     pos => [0,0],
     bb => [],
     wall => {}, # walls
     s => { hk(0,0) => 0, }, # steps
     v => {},
     dist => 0,
    };
  minmax_xy($D->{bb}, @{$D->{pos}});
  my $ic = IntCode->new($prog,
                        sub {
                          my $min;
                          for my $dir (1 .. 4) {
                            my $dirstr = dirstr($dir);
                            my $diroff = compassOffset($dirstr);
                            my $nx = $D->{pos}->[X] + $diroff->[X];
                            my $ny = $D->{pos}->[Y] + $diroff->[Y];
                            next if (exists $D->{wall}->{hk($nx,$ny)});
                            my $v = $D->{v}->{hk($nx,$ny)} // 0;
                            if (!defined $min || $v < $min) {
                              $min = $v;
                              $D->{dir} = $dir
                            }
                          }
                          return $D->{dir};
                        });
  my $count = 0;
  my $prev = "";
  while (!$ic->{done}) {
    my $rc = $ic->run();
    if (@{$ic->{o}} == 1) {
      my $res = shift @{$ic->{o}};
      my $dirstr = dirstr($D->{dir});
      my $diroff = compassOffset($dirstr);
      my $nx = $D->{pos}->[X] + $diroff->[X];
      my $ny = $D->{pos}->[Y] + $diroff->[Y];
      minmax_xy($D->{bb}, $nx, $ny);
      $D->{v}->{hk($nx,$ny)}++;
      if ($res == 2) {
        $D->{oxy}->[X] = $nx;
        $D->{oxy}->[Y] = $ny;
        $D->{pos}->[X] = $nx;
        $D->{pos}->[Y] = $ny;
      } elsif ($res == 0) {
        $D->{wall}->{hk($nx,$ny)} = '#';
        #print "Failed to move ", $dirstr, "(", $D->{dir}, ")\n";
      } elsif ($res == 1) {
        #print "Moved $dirstr from ", posstr($D->{pos}), " to ";
        $D->{pos}->[X] = $nx;
        $D->{pos}->[Y] = $ny;
        $count++;
        my $n = draw($D);
        print `tput cup 0 0`;
        print $n, "\n";
        print "Count: $count\n";
        if (($count%1000) == 0) {
          $n =~ s/D/./;
          if ($n eq $prev) {
            print `tput cup 0 0`;
            print $n, "\n";
            last;
          }
          $prev = $n;
        }
      }
    }
  }
  return;
}

print `tput clear`;
find_maze($i);
print "\n\n";
