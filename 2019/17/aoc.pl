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
  my $bot = '^';
  if (exists $D->{dir}) {
    $bot = {
            '0!1' => 'v', '-1!0' => '<', '1!0' => '>', '0!-1' => '^'
           }->{hk(@{$D->{dir}})};
  }
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      if ($x == $D->{bot}->[X] && $y == $D->{bot}->[Y]) {
        $s .= $bot;
      } else {
        $s .= $D->{m}->{hk($x,$y)} ? '#' : '.';
      }
    }
    $s .= "\n";
  }
  return $s;
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
     m => {},
     bot => [-1,-1],
     dir => [0,-1],
    };
  minmax_xy($D->{bb}, @{$D->{pos}});
  my $ic = IntCode->new($prog,
                        sub {
                          return 0;
                        });
  my $count = 0;
  my $res = 0;
  while (!$ic->{done}) {
    my $rc = $ic->run();
    if (@{$ic->{o}} == 1) {
      my $char = pop @{$ic->{o}};
      if ($char == 10) {
        $D->{pos}->[Y]++;
        $D->{pos}->[X]=0;
      } elsif ($char == 46) {
        $D->{pos}->[X]++;
      } elsif ($char == 35) {
        $D->{m}->{hk(@{$D->{pos}})} = '#';
        $D->{pos}->[X]++;
      } elsif ($char == 94) {
        $D->{m}->{hk(@{$D->{pos}})} = '#';
        $D->{bot} = [ @{$D->{pos}} ];
        $D->{pos}->[X]++;
      } else {
        $D->{pos}->[X]++;
      }
      minmax_xy($D->{bb}, @{$D->{pos}});
    }
  }
  print draw($D) if DEBUG;
  my $ans = 0;
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      if (exists $D->{m}->{hk($x,$y)} &&
          exists $D->{m}->{hk($x-1,$y)} &&
          exists $D->{m}->{hk($x,$y-1)} &&
          exists $D->{m}->{hk($x+1,$y)} &&
          exists $D->{m}->{hk($x,$y+1)}) {
        $ans += $x * $y;
      }
    }
  }
  print "Part 1: ", $ans, "\n";
  return $D;
}

my $D = find_maze($i);
my $pos = $D->{bot};
my $dir = [0,-1];
my @path = ();

sub turns {
  my ($dir) = @_;
  return {
          '0!-1' => { 'L' => [-1,0], 'R' => [1,0] },
          '0!1' => { 'L' => [1,0], 'R' => [-1,0] },
          '-1!0' => { 'R' => [0,-1], 'L' => [0,1] },
          '1!0' => { 'L' => [0,-1], 'R' => [0,1] },
         }->{hk(@$dir)};
}

while (1) {
  print draw($D), "\n" if DEBUG;
  #select undef, undef,undef, 0.05;
  my $nx = $pos->[X] + $dir->[X];
  my $ny = $pos->[Y] + $dir->[Y];
  print "From @{$pos} in @{$dir}, continue forward to $nx, $ny?\n" if DEBUG;
  if (exists $D->{m}->{hk($nx,$ny)}) {
    print "Forward to $nx, $ny\n" if DEBUG;
    push @path, 'F';
    $pos = [$nx, $ny];
    $D->{bot} = $pos;
    $D->{dir} = $dir;
  } else {
    my $turns = turns($dir);
    my $nx = $pos->[X] + $turns->{L}->[X];
    my $ny = $pos->[Y] + $turns->{L}->[Y];
    if (exists $D->{m}->{hk($nx,$ny)}) {
      $D->{dir} = $dir = $turns->{L};
      print "Turn left @{$dir}\n" if DEBUG;
      push @path, 'L';
    } else {
      my $nx = $pos->[X] + $turns->{R}->[X];
      my $ny = $pos->[Y] + $turns->{R}->[Y];
      if (exists $D->{m}->{hk($nx,$ny)}) {
        $D->{dir} = $dir = $turns->{R};
        print "Turn right @{$dir}\n" if DEBUG;
        push @path, 'R';
      } else {
        print "Turn no turn worked done?\n" if DEBUG;
        last;
      }
    }
  }
}
my $path = join '', @path;
$path=~s/ //g;
$path=~s/(F+)/length($1)/ge;

sub nextfun {
  my ($path, $offset, $letter) = @_;
  my $shortest;
  my $ssub;
  for my $i (1..12) {
    my $n = $path;
    my $sub = substr $path, $offset, $i;
    $n =~ s/$sub/$letter/g;
    if (!defined $shortest || length($shortest) > length($n)) {
      $shortest = $n;
      $ssub = $sub;
    }
  }
  $ssub =~ s/[^0-9]$//; # only end in digits?
  return $ssub;
}

print "Path: $path\n" if DEBUG;
my $A = nextfun($path, 0, 'A');
print "A=$A\n" if DEBUG;
$path =~ s/$A/A/g;
print "Path reduced by A: ", $path, "\n" if DEBUG;
$path =~ /[^A]/g;
my $offset = pos($path) - 1;
print "Offset after A: $offset\n" if DEBUG;
my $B = nextfun($path, $offset, 'B');
print "B=$B\n" if DEBUG;
$path =~ s/$B/B/g;
print "Path reduced by B: ", $path, "\n" if DEBUG;
$path =~ /[^AB]/g;
$offset = pos($path) - 1;
print "Offset after B: $offset\n" if DEBUG;
my $C = nextfun($path, $offset, 'C');
print "C=$C\n" if DEBUG;
$path =~ s/$C/C/g;
print "Path reduced by C: ", $path, "\n" if DEBUG;

my $M = (join ',', split //, $path);
$A =~ s/(\d+)/,$1,/g; $A =~ s/,$//;
$B =~ s/(\d+)/,$1,/g; $B =~ s/,$//;
$C =~ s/(\d+)/,$1,/g; $C =~ s/,$//;

my $E = "n\n";

my @PROG = map { ord($_) } split //, join "\n", $M, $A, $B, $C, $E;
my $prog = parse_input(\@i);
$prog->[0] = 2;
my $ic = IntCode->new($prog, sub { return shift @PROG; });
my $last = 0;
while (!$ic->{done}) {
  my $rc = $ic->run();
  if (@{$ic->{o}} == 1) {
    $last = pop @{$ic->{o}};
  }
}

print "Part 2: ", $last, "\n";

