#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

#use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";

my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_lines($file);
  my %m;
  my @z;
  for (@$in) {
    my $k;
    if (/^(\w+) (\w+) (\w+) -> (\w+)$/) {
      $m{$4} = [$1, $2, $3];
      $k = $4;
    } elsif (/^(\w+): (\d)$/) {
      $m{$1} = $2 + 0;
      $k = $1;
    } elsif (/^$/) {
      next;
    } else {
      die;
    }
    push @z, $k if ($k =~ /^z/);
  }
  @z = reverse sort @z;
  return [\%m, \@z];
}

sub V {
  my ($m, $k) = @_;
  my $v = $m->{$k};
  return $v unless (ref $v);
  my ($a, $op, $b) = @$v;
  my $na = V($m, $a);
  my $nb = V($m, $b);
  if ($op eq 'AND') {
    return ($na & $nb) ? 1 : 0;
  } elsif ($op eq 'OR') {
    return ($na | $nb) ? 1 : 0;
  } elsif ($op eq 'XOR') {
    return ($na ^ $nb) ? 1 : 0;
  }
  die "$a $op $b?";
}

sub N {
  my ($m, $b) = @_;
  my $r = 0;
  $r = ($r << 1) + V($m, $_) for (@$b);
  return $r;
}
use constant {
  A => 0,
  OP => 1,
  B => 2,
};

sub calc {
  my ($in) = @_;
  my %m = %{$in->[0]};
  my @z = @{$in->[1]};
  my $p1 = N($in->[0], \@z);
  if (@z < 20) {
    return [$p1, "test"];
  }
  my %bad;
  for my $n (1 .. 44) {
    my $z = sprintf "z%02d", $n;
    my $y = sprintf "y%02d", $n;
    my $x = sprintf "x%02d", $n;
    my $Y = sprintf "y%02d", $n - 1;
    my $X = sprintf "x%02d", $n - 1;
    my $g0 = $m{$z};
    unless ($g0->[OP] eq 'XOR') {
      push @{$bad{$z}}, $z . ' should be XOR';
      next;
    }
    my $ga = $m{$g0->[A]};
    my $gb = $m{$g0->[B]};
    my $gxor;
    my $gor;
    if ($ga->[OP] eq 'XOR' && ("@$ga" eq "$x,XOR,$y" || "@$ga" eq "$y,XOR,$x"))
    {
      $gxor = $ga;
      if ($gb->[OP] ne 'OR') {
        if ($z eq 'z01') {
          if ($gb->[OP] eq 'AND') {
            next;
          } else {
            push @{$bad{$z}}, 'z01.XOR should include AND';
            next;
          }
        }
        push @{$bad{$g0->[B]}}, $z . '.XOR.B should include OR';
        next;
      }
      $gor = $gb;
    } elsif ($gb->[OP] eq 'XOR'
      && ("@$gb" eq "$x,XOR,$y" || "@$gb" eq "$y,XOR,$x"))
    {
      $gxor = $gb;
      if ($ga->[OP] ne 'OR') {
        if ($z eq 'z01') {
          if ($gb->[OP] eq 'AND') {
            next;
          } else {
            push @{$bad{$z}}, 'z01.XOR should include AND';
            next;
          }
        }
        push @{$bad{$g0->[A]}}, $z . '.XOR.A should include OR';
        next;
      }
      $gor = $ga;
    } else {
      if ($gb->[OP] eq 'AND') {
        push @{$bad{$g0->[B]}}, $z . '.XOR.B should not be AND';
        next;
      }
      if ($ga->[OP] eq 'AND') {
        push @{$bad{$g0->[A]}}, $z . '.XOR.A should not be AND';
        next;
      }
      print STDERR "0? $z: @$g0 => @$ga @$gb\n";
      next;
    }
    my $gora = $m{$gor->[A]};
    my $gorb = $m{$gor->[B]};

    #print "?? @$gor => @{$gora} @{$gorb}\n";
  }
  if (1) {
    for my $k (keys %m) {
      next unless (ref $m{$k});
      my ($a, $g, $b) = @{$m{$k}};
      if ($k eq 'z45') {
        push @{$bad{$k}}, 'z45 should be OR!' unless ($m{$k}->[OP] eq 'OR');
        next;
      }
      if ($k eq 'z00') {
        push @{$bad{$k}}, 'z00 should be AND!' unless ($m{$k}->[OP] eq 'AND');
        next;
      }
      if ($k =~ /^z(\d+)/) {
        my $x = 'x' . $1;
        my $y = 'y' . $1;
        unless ($m{$k}->[OP] eq 'XOR') {
          push @{$bad{$k}}, $k . ' should be XOR!';
          next;
        }
        my $ga = $m{$a};
        my $gb = $m{$b};
        print STDERR "3? $k: $a $g $b => @$ga @$gb\n";
        if ("@$ga" eq "$x,XOR,$y" || "@$ga" eq "$y,XOR,$x") {
          push @{$bad{$b}}, $b . ' XOR should have OR child!'
            unless ($gb->[OP] eq 'OR');
        } elsif ("@$gb" eq "$x,XOR,$y" || "@$gb" eq "$y,XOR,$x") {
          push @{$bad{$a}}, $a . ' XOR should have OR child!'
            unless ($ga->[OP] eq 'OR');
        }
        next;
      }
      if ($g eq 'XOR') {
        if ($a =~ /^x(\d+)$/ && $b eq "y$1") {
          next;
        }
        if ($b =~ /^x(\d+)$/ && $a eq "y$1") {
          next;
        }
        push @{$bad{$k}}, $k . ' XOR only xNN/yNN!';
      } elsif ($g eq 'AND') {
        if ($a =~ /^y(\d+)$/ && $b eq "x$1") {
          next;
        }
        if ($a =~ /^x(\d+)$/ && $b eq "y$1") {
          next;
        }
        my $op_a = $m{$a}->[1];
        my $op_b = $m{$a}->[1];
        if ($op_a eq 'OR' && $op_b eq 'XOR') {
          next;
        }
        if ($op_b eq 'OR' && $op_a eq 'XOR') {
          next;
        }

        #print STDERR "$k: $a $g $b $op_a $op_b\n";
      } elsif ($g eq 'OR') {
        if ($m{$a}->[1] ne 'AND') {
          push @{$bad{$a}}, $a . ' OR child must be AND!';
        }
        if ($m{$b}->[1] ne 'AND') {
          push @{$bad{$b}}, $b . ' OR child must be AND!';
        }

        #print "$k: $a $g $b\n";
      }
    }
  }
  my @p2 = sort keys %bad;
  dd([\%bad], [qw/bad/]);
  return [$p1, join ',', @p2];
}

sub op {
  my ($m, $s) = @_;
  ref $m->{$s} ? $m->{$s}->[1] : '=' . $m->{$s};
}

RunTests(sub {my $f = shift; calc($reader->($f), @_)}) if (TEST);

my $res = calc($i);
printf "Part 1: %s\nPart 2: %s\n", @$res;
