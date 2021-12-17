package IntCode;
use strict;
use warnings;
use v5.10;

use constant
  {
   DEBUG => $ENV{AoC_DEBUG}//0,
  };

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();
our $VERSION = '0.01';

sub new {
  my ($pkg, $prog, $i) = @_;
  return bless { ip => 0, p => [@$prog], o => [], i => $i,
                 b => 0, name => "" }, $pkg;
}

sub pp {
  my ($self) = @_;
  my $l = main::min($self->{ip} + 3, @{$self->{p}}-1);
  return "ip=$self->{ip}: [",
    (join " ", map { $self->{p}->[$_]//0 } ($self->{ip} .. $l)), "] b=",
    $self->{b};
}

sub hexdump {
  my ($self) = @_;
  my $s = "";
  for (my $i = 0; $i < @{$self->{p}}; $i += 8) {
    $s .= sprintf "%s %08d: ", $self->{name}, $i;
    for my $j (0..7) {
      my $addr = $i + $j;
      last if ($addr >= @{$self->{p}});
      $s .= sprintf "%6d ", $self->{p}->[$addr];
    }
    $s .= "\n";
  }
  return $s;
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
    #print $self->hexdump();
    printf("%s ip=%d %d,%d,%d,%d\n",
           $self->{name}, $self->{ip}, map { $self->{p}->[$self->{ip}+$_]//0
                                           } (0..3)) if (DEBUG > 2);
    my $inst = $self->parse_inst();
    printf "op=%d param=%s addr=%s\n",
      $inst->{op}, ppv($inst->{param}), ppv($inst->{addr}) if (DEBUG > 2);
    my $op = $inst->{op};
    if ($op == 1) {
      printf "$self->{name} add %d + %d = %d => %d\n",
        $inst->{param}->[0], $inst->{param}->[1],
        $inst->{param}->[0] + $inst->{param}->[1],
        $inst->{addr}->[2] if (DEBUG > 2);
      $self->{p}->[$inst->{addr}->[2]] =
        $inst->{param}->[0] + $inst->{param}->[1];
    } elsif ($op == 2) {
      printf "$self->{name} mul %d * %d = %d => %d\n",
        $inst->{param}->[0], $inst->{param}->[1],
        $inst->{param}->[0] * $inst->{param}->[1],
        $inst->{addr}->[2] if (DEBUG > 2);
      $self->{p}->[$inst->{addr}->[2]] =
        $inst->{param}->[0] * $inst->{param}->[1];
    } elsif ($op == 3) {
      my $v = shift @{$self->{i}};
      if (!defined $v) {
        $self->{ip} -= arity($op)+1;
        return 2;
      }
      printf "$self->{name} read %d => %d\n", $v, $inst->{addr}->[0]
        if (DEBUG > 2);
      $self->{p}->[$inst->{addr}->[0]] = $v;
    } elsif ($op == 4) {
      printf "$self->{name} write %d => output\n",
        $inst->{param}->[0] if (DEBUG > 2);
      push @{$self->{o}}, $inst->{param}->[0];
      return 0;
    } elsif ($op == 5) {
      printf "$self->{name} jnz %d to %d\n",
        $inst->{param}->[0], $inst->{param}->[1] if (DEBUG > 2);
      if ($inst->{param}->[0] != 0) {
        $self->{ip} = $inst->{param}->[1];
      }
    } elsif ($op == 6) {
      printf "$self->{name} jz %d to %d\n",
        $inst->{param}->[0], $inst->{param}->[1] if (DEBUG > 2);
      if ($inst->{param}->[0] == 0) {
        $self->{ip} = $inst->{param}->[1];
      }
    } elsif ($op == 7) {
      printf "$self->{name} lt %d < %d => %d\n",
        $inst->{param}->[0], $inst->{param}->[1], $inst->{addr}->[2]
        if (DEBUG > 2);
      $self->{p}->[$inst->{addr}->[2]] =
        $inst->{param}->[0] < $inst->{param}->[1] ? 1 : 0;
    } elsif ($op == 8) {
      printf "$self->{name} eq %d == %d => %d\n",
        $inst->{param}->[0], $inst->{param}->[1], $inst->{addr}->[2]
        if (DEBUG > 2);
      $self->{p}->[$inst->{addr}->[2]] =
        $inst->{param}->[0] == $inst->{param}->[1] ? 1 : 0;
    } elsif ($op == 9) {
      $self->{b} += $inst->{param}->[0];
      printf "$self->{name} base += %d == %d\n",
        $inst->{param}->[0], $self->{b} if (DEBUG > 2);
    } elsif ($op == 99) {
      $self->{done}=1;
      return 1;
    } else {
      die "err\n";
      return -1;
    }
    if ($self->{run_one}) {
      return 3;
    }
  }
}

1;
