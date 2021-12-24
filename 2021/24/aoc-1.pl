#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
$; = $" = ',';
my $model = shift // 99999999999999;
my @inp = split //, $model;
my $r = prog();
print "\n$r\n";

sub prog {
  my $x = 0;
  my $y = 0;
  my $z = 0;
  return inp0($z, "");
}

sub inp0 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[0]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $x += 13;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 8;
  $y *= $x;
  $z += $y;

    my $r = inp1($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp1 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[1]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $x += 12;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 16;
  $y *= $x;
  $z += $y;

    my $r = inp2($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp2 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[2]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $x += 10;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 4;
  $y *= $x;
  $z += $y;

    my $r = inp3($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp3 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[3]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $z = int($z / 26);
  $x += -11;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 1;
  $y *= $x;
  $z += $y;

    my $r = inp4($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp4 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[4]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $x += 14;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 13;
  $y *= $x;
  $z += $y;

    my $r = inp5($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp5 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});
print STDERR "$ws.........\r";

  for my $wi (reverse 1 .. $inp[5]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $x += 13;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 5;
  $y *= $x;
  $z += $y;

    my $r = inp6($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp6 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[6]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $x += 12;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 0;
  $y *= $x;
  $z += $y;

    my $r = inp7($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp7 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[7]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $z = int($z / 26);
  $x += -5;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 10;
  $y *= $x;
  $z += $y;

    my $r = inp8($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp8 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[8]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $x += 10;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 7;
  $y *= $x;
  $z += $y;

    my $r = inp9($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp9 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[9]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $z = int($z / 26);
  $x += 0;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 2;
  $y *= $x;
  $z += $y;

    my $r = inp10($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp10 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[10]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $z = int($z / 26);
  $x += -11;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 13;
  $y *= $x;
  $z += $y;

    my $r = inp11($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp11 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[11]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $z = int($z / 26);
  $x += -13;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 15;
  $y *= $x;
  $z += $y;

    my $r = inp12($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp12 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[12]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $z = int($z / 26);
  $x += -13;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 14;
  $y *= $x;
  $z += $y;

    my $r = inp13($z, $ws.$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}

sub inp13 {
  my ($zi, $ws) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});

  for my $wi (reverse 1 .. $inp[13]) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
  $x = $z;
  $x %= 26;
  $z = int($z / 26);
  $x += -11;
  $x = $x == $w ? 0 : 1;
  $y = 25;
  $y *= $x;
  $y += 1;
  $z *= $y;
  $y = $w;
  $y += 9;
  $y *= $x;
  $z += $y;

    return $ws.$wi if ($z == 0);
  }
  $cache{$zi} = undef;
  return
}
